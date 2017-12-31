require_relative '../../spec_helper'
require 'app/models/user'

describe EBL::Models::User, type: :model do
  it { is_expected.to validate_max_length 50, :username }
  it { is_expected.to validate_max_length 100, :password }

  it 'validates that username only contains alphanumeric characters' do
    subject.username = 'test'
    subject.password = 'test'
    expect(subject.valid?).to be true

    subject.username = 'test!'
    expect(subject.valid?).to be false
  end

  describe '#create_password_hash' do
    it 'returns the bcrypt hash of plain_text' do
      hash = BCrypt::Password.new(subject.create_password_hash('test'))
      expect(hash).to eq 'test'
    end

    it 'sets #password to the value of the generated hash' do
      subject.create_password_hash 'test'
      hash = BCrypt::Password.new(subject.password)
      expect(hash).to eq 'test'
    end
  end

  describe '.find_and_verify' do
    context 'when the user does not exist' do
      it 'returns nil' do
        expect(EBL::Models::User.find_and_verify('a', 'a')).to be_nil
      end
    end

    context 'when the password does not match' do
      it 'returns nil' do
        user = EBL::Models::User.new
        user.username = 'test'
        user.create_password_hash 'test'
        user.save

        result = EBL::Models::User.find_and_verify('test', 'incorrect')
        expect(result).to be_nil
      end
    end

    context 'when the user exists and the password is correct' do
      it 'returns the user model' do
        user = EBL::Models::User.new
        user.username = 'test'
        user.create_password_hash 'test'
        user.save

        result = EBL::Models::User.find_and_verify('test', 'test')
        expect(result).to be_a_kind_of EBL::Models::User
        expect(result.username).to eq 'test'
      end
    end
  end
end
