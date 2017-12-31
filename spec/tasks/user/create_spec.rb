require_relative '../../spec_helper'
load 'tasks/user/create.rake'

describe 'rake user:create', type: :task do
  let(:subject) { Rake::Task['user:create'] }
  let(:username_input) { 'test' }
  let(:password_input) { 'test' }

  before(:each) do
    allow_any_instance_of(EBL::InputHandler).to receive(
      :get_alphanumeric_value
    ).and_return username_input

    allow_any_instance_of(EBL::InputHandler).to receive(
      :get_password
    ).and_return password_input

    allow_any_instance_of(EBL::Logger).to receive(:log).and_return true
  end

  it 'prompts the user for a username between 3 and 50 chars' do
    prompted = false
    allow_any_instance_of(EBL::InputHandler).to receive(:get_alphanumeric_value) do |_t, p1, p2, p3|
      prompted = (p1 == 'username') && (p2 == 3) && (p3 == 50)
      nil
    end

    subject.execute
    expect(prompted).to be true
  end

  it 'logs an error if the user already exists' do
    EBL::Models::User.create(username: 'test', password: 'test')
    logged = false
    allow_any_instance_of(EBL::Logger).to receive(:log) do |_t, p1, p2|
      logged = (p1 == 'test already exists') && (p2 == :red)
    end

    subject.execute
    expect(logged).to be true
  end

  it 'prompts for a password with a min length of 4' do
    prompted = false
    allow_any_instance_of(EBL::InputHandler).to receive(:get_password) do |_t, p1|
      prompted = p1 == 4
    end

    subject.execute
    expect(prompted).to be true
  end

  it 'creates a new user if valid information is provided' do
    subject.execute
    user = EBL::Models::User.find_and_verify('test', 'test')
    expect(user).to be_a_kind_of EBL::Models::User
    expect(user.username).to eq username_input
  end
end
