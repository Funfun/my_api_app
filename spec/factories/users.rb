FactoryGirl.define do
  factory :user do
    login "bob"
    password_digest "$2a$04$Yd06OUhHCs/sDfub5nQITuxLmnCRCL5bxsUWuPCBS7G2gDLtWjzfa"
    role Role::GUEST
  end
end
