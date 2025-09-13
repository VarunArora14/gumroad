import * as React from "react";

import { Icon } from "$app/components/Icons";
import { Popover } from "$app/components/Popover";

interface SelectOption<T extends string> {
  value: T;
  label: string;
}

interface SelectPopoverProps<T extends string> {
  options: SelectOption<T>[];
  value: T;
  onChange: (value: T) => void;
  ariaLabel?: string;
}

export function SelectPopover<T extends string>({ options, value, onChange, ariaLabel }: SelectPopoverProps<T>) {
  const selectedOption = options.find((opt) => opt.value === value);
  const groupName = React.useId();

  return (
    <Popover
      trigger={
        <span className="input flex min-w-[150px] items-center justify-between" aria-label={ariaLabel}>
          {selectedOption?.label || "Select..."}
          <Icon name="outline-cheveron-down" />
        </span>
      }
    >
      <fieldset>
        {options.map((option) => (
          <label key={option.value} className="pointer flex items-center gap-2">
            <input
              name={groupName}
              type="radio"
              value={option.value}
              checked={value === option.value}
              onChange={() => onChange(option.value)}
            />
            {option.label}
          </label>
        ))}
      </fieldset>
    </Popover>
  );
}
