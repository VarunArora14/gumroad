# frozen_string_literal: true

require "spec_helper"

describe AttributeBlockable do
  let(:blocked_email) { "blocked@example.com" }
  let(:unblocked_email) { "unblocked@example.com" }
  let(:user_with_blocked_email) { create(:user, email: blocked_email) }
  let(:user_with_unblocked_email) { create(:user, email: unblocked_email) }

  before do
    BlockedObject.block!(BLOCKED_OBJECT_TYPES[:email], blocked_email, 1)
  end

  after do
    BlockedObject.delete_all
  end

  describe ".attr_blockable" do
    it "defines blocked? methods for the specified attribute" do
      expect(user_with_blocked_email).to respond_to(:email_blocked_at?)
      expect(user_with_blocked_email).to respond_to(:email_blocked?)
      expect(user_with_blocked_email).to respond_to(:email_blocked_at)
    end

    it "defines blocked? methods for custom method names" do
      expect(user_with_blocked_email).to respond_to(:form_email_blocked_at?)
      expect(user_with_blocked_email).to respond_to(:form_email_blocked?)
      expect(user_with_blocked_email).to respond_to(:form_email_blocked_at)
    end

    describe "generated instance methods" do
      describe "#email_blocked?" do
        it "returns true for blocked emails" do
          expect(user_with_blocked_email.email_blocked?).to be true
        end

        it "returns false for unblocked emails" do
          expect(user_with_unblocked_email.email_blocked?).to be false
        end

        it "returns false for blank email" do
          user = create(:user)
          user.update_column(:email, "")
          expect(user.email_blocked?).to be false
        end
      end

      describe "#email_blocked_at?" do
        it "returns true for blocked emails" do
          expect(user_with_blocked_email.email_blocked_at?).to be true
        end

        it "returns false for unblocked emails" do
          expect(user_with_unblocked_email.email_blocked_at?).to be false
        end
      end

      describe "#email_blocked_at" do
        it "returns blocked_at timestamp for blocked emails" do
          blocked_at = user_with_blocked_email.email_blocked_at
          expect(blocked_at).to be_a(DateTime)
          expect(blocked_at.to_time).to be_within(1.minute).of(Time.current)
        end

        it "returns nil for unblocked emails" do
          expect(user_with_unblocked_email.email_blocked_at).to be_nil
        end

        it "caches the result in blocked_by_attributes" do
          user_with_blocked_email.email_blocked_at
          expect(user_with_blocked_email.blocked_by_attributes["email"]).not_to be_nil
        end

        it "uses cached value on subsequent calls" do
          first_result = user_with_blocked_email.email_blocked_at

          blocked_object = BlockedObject.find_by(object_value: blocked_email)
          blocked_object.update!(blocked_at: 1.year.ago)

          second_result = user_with_blocked_email.email_blocked_at
          expect(second_result).to eq(first_result)
        end
      end

      describe "#form_email_blocked?" do
        it "uses the email attribute for blocking checks" do
          expect(user_with_blocked_email.form_email_blocked?).to be true
          expect(user_with_unblocked_email.form_email_blocked?).to be false
        end
      end
    end
  end

  describe ".with_blocked_attributes_for" do
    let!(:users) { 3.times.map { |i| create(:user, email: "unblocked#{i}@example.com") } }
    let!(:blocked_user) { create(:user, email: blocked_email) }

    it "returns an ActiveRecord::Relation" do
      result = User.with_blocked_attributes_for(:email)
      expect(result).to be_a(ActiveRecord::Relation)
    end

    it "maintains chainability" do
      result = User.with_blocked_attributes_for(:email).where(id: users.map(&:id))
      expect(result).to be_a(ActiveRecord::Relation)
      expect(result.to_a.size).to eq(3)
    end

    it "can chain additional scopes" do
      result = User.with_blocked_attributes_for(:email)
                   .where(email: blocked_email)
                   .limit(1)

      expect(result).to be_a(ActiveRecord::Relation)
      expect(result.first).to eq(blocked_user)
    end

    it "accepts multiple method names" do
      result = User.with_blocked_attributes_for(:email, :form_email)
      expect(result).to be_a(ActiveRecord::Relation)
    end

    describe "bulk loading blocked attributes" do
      it "correctly identifies blocked and unblocked records" do
        all_users = User.with_blocked_attributes_for(:email)
        blocked_users = all_users.select(&:email_blocked?)
        unblocked_users = all_users.reject(&:email_blocked?)

        expect(blocked_users.map(&:email)).to include(blocked_email)
        expect(unblocked_users.map(&:email)).not_to include(blocked_email)
      end

      it "populates blocked_by_attributes for all records" do
        users_with_preload = User.with_blocked_attributes_for(:email).to_a

        users_with_preload.each do |user|
          if user.email == blocked_email
            expect(user.blocked_by_attributes["email"]).to be_a(DateTime)
          else
            expect(user.blocked_by_attributes["email"]).to be_nil
          end
        end
      end

      it "handles mixed blocked and unblocked records" do
        mixed_blocked_email = "mixed_blocked@example.com"
        mixed_emails = [mixed_blocked_email, "unique_unblocked@example.com", "another@example.com"]

        BlockedObject.block!(BLOCKED_OBJECT_TYPES[:email], mixed_blocked_email, 1)
        BlockedObject.block!(BLOCKED_OBJECT_TYPES[:email], "another@example.com", 1)

        mixed_users = mixed_emails.map { |email| create(:user, email:) }

        result = User.where(id: mixed_users.map(&:id)).with_blocked_attributes_for(:email)
        blocked_users = result.select(&:email_blocked?)

        expect(blocked_users.map(&:email)).to eq([mixed_blocked_email, "another@example.com"])
      end
    end

    describe "performance" do
      it "makes only one MongoDB query when loading blocked attributes for multiple blocked users" do
        perf_users = []
        5.times do |i|
          email = "blocked_perfuser#{i}@example.com"
          perf_users << create(:user, email:)
          BlockedObject.block!(BLOCKED_OBJECT_TYPES[:email], email, 1)
        end

        allow(BlockedObject).to receive(:find_active_objects).and_call_original

        result = User.where(id: perf_users.map(&:id)).with_blocked_attributes_for(:email)

        expect(result.size).to eq(5)
        result.each do |user|
          expect(user.blocked_by_attributes["email"]).to be_a(DateTime)
          expect(user.email_blocked?).to be true
        end

        expect(BlockedObject).to have_received(:find_active_objects).once
      end

      it "handles empty result sets gracefully" do
        result = User.where(id: -1).with_blocked_attributes_for(:email)
        expect(result).to be_empty
      end

      it "handles records with nil values" do
        user_with_nil_email = create(:user)
        user_with_nil_email.update_column(:email, nil)
        result = User.with_blocked_attributes_for(:email).find_by(id: user_with_nil_email.id)

        expect(result.email_blocked?).to be false
        expect(result.email_blocked_at).to be_nil
      end
    end
  end

  describe "different blocked object types" do
    let(:blocked_ip) { "192.168.1.100" }
    let(:unblocked_ip) { "192.168.1.200" }

    before do
      BlockedObject.block!(BLOCKED_OBJECT_TYPES[:ip_address], blocked_ip, 1, expires_in: 1.hour)
    end

    let(:test_model_class) do
      Class.new(ApplicationRecord) do
        self.table_name = "users"
        include AttributeBlockable

        attr_blockable :current_sign_in_ip, attribute: :current_sign_in_ip

        def self.name
          "TestModel"
        end
      end
    end

    it "works with different BLOCKED_OBJECT_TYPES" do
      model = test_model_class.new(current_sign_in_ip: blocked_ip)
      expect(model.current_sign_in_ip_blocked?).to be true

      model2 = test_model_class.new(current_sign_in_ip: unblocked_ip)
      expect(model2.current_sign_in_ip_blocked?).to be false
    end
  end

  describe "edge cases and error handling" do
    it "handles missing BLOCKED_OBJECT_TYPES gracefully" do
      user = create(:user, username: "testuser")

      expect do
        user.blocked_at_by_method(:username)
      end.not_to raise_error
    end

    it "handles expired blocked objects" do
      expired_email = "expired@example.com"

      BlockedObject.create!(
        object_type: BLOCKED_OBJECT_TYPES[:email],
        object_value: expired_email,
        blocked_at: 1.hour.ago,
        expires_at: 30.minutes.ago,
        blocked_by: 1
      )

      user = create(:user, email: expired_email)
      expect(user.email_blocked?).to be false
    end

    it "handles blocked objects without expires_at" do
      permanent_blocked_email = "permanent@example.com"

      BlockedObject.create!(
        object_type: BLOCKED_OBJECT_TYPES[:email],
        object_value: permanent_blocked_email,
        blocked_at: 1.hour.ago,
        expires_at: nil,
        blocked_by: 1
      )

      user = create(:user, email: permanent_blocked_email)
      expect(user.email_blocked?).to be true
    end
  end

  describe "integration with blocked_by_attributes" do
    it "initializes with empty hash" do
      user = User.new
      expect(user.blocked_by_attributes).to eq({})
    end

    it "persists cached blocked attributes" do
      user = create(:user, email: blocked_email)
      expect(user.blocked_by_attributes["email"]).to be_nil
      user.email_blocked? # Populate cache
      expect(user.blocked_by_attributes["email"]).to be_a(DateTime)
      user.reload # Clear cache
      expect(user.blocked_by_attributes["email"]).to be_nil
      expect(user.email_blocked?).to be true
    end
  end
end
