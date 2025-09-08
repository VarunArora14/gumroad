import React from "react";
import { useForm } from '@inertiajs/react';
import { showAlert } from "$app/components/server-components/Alert";

export type Props = {
  action: string;
  authenticity_token: string;
  header: string;
  button_label: string;
  notice_message: string;
};

const Form = ({
  action,
  authenticity_token,
  header,
  button_label,
  notice_message
}: Props) => {
  const { data, setData, put, reset } = useForm({
    authenticity_token,
    email_domains: {
      identifiers: "",
    },
  });

  const handleSubmit = (event: React.FormEvent<HTMLFormElement>) => {
    event.preventDefault();

    put(action, {
      onSuccess: () => {
        showAlert(notice_message, "success");
        reset();
      },
    });
  };

  const setIdentifiers = (event: React.ChangeEvent<HTMLTextAreaElement>) => {
    setData("email_domains.identifiers", event.target.value);
  };

  return (
    <form onSubmit={handleSubmit}>
      <section>
        <input type="hidden" name="authenticity_token" value={data.authenticity_token} />

        <header>{header}</header>

        <p>
          For emails like <code>john@example.com</code>, <code>john@example.net</code>, <code>john@list.example.org</code>, enter what is to the right of the <code>@</code> character.
        </p>

        <figure className="code">
          <figcaption>
            Example with comma-separated items
          </figcaption>
          <pre>example.com, example.net, list.example.org</pre>
        </figure>

        <figure className="code">
          <figcaption>
            Example with items separated by newline
          </figcaption>
          <pre>
            example.com
            <br />
            example.net
            <br />
            list.example.org
          </pre>
        </figure>

        <textarea
          id="identifiers"
          name="email_domains[identifiers]"
          placeholder="Enter email domains here"
          rows={10}
          value={data.email_domains.identifiers}
          onChange={setIdentifiers}
          autoComplete="off"
        />

        <button type="submit" className="button primary">{button_label}</button>
      </section>
    </form>
  );
};

export default Form;
