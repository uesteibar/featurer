require 'spec_helper'

describe Featurer do
  describe 'feature flag is defined' do
    after(:each) { Featurer.delete(:feature) }

    before do
      Featurer.init!
    end

    let(:user_id) { 1 }

    describe 'per user' do
      it 'returns true because user is in the list' do
        Featurer.register :feature, [user_id]
        expect(Featurer.on?(:feature, user_id)).to be
      end

      it 'defines the user twice and returns true' do
        Featurer.register :feature, [user_id]
        Featurer.register :feature, [user_id]
        expect(Featurer.on?(:feature, user_id)).to be
      end

      it 'returns false because user is not in the list' do
        Featurer.register :feature, [user_id + 1]
        expect(Featurer.on?(:feature, user_id)).to_not be
      end

      it 'converts a per user feature into a global one' do
        Featurer.register :feature, [user_id]
        Featurer.register :feature, true

        expect(Featurer.on?(:feature)).to be
        expect(Featurer.on?(:feature, user_id)).to_not be
      end
    end

    describe 'global' do
      it 'returns true because the feature is enabled(default)' do
        Featurer.register :feature
        expect(Featurer.on?(:feature)).to be
      end

      it 'returns true because the feature is enabled(manually)' do
        Featurer.register :feature, true
        expect(Featurer.on?(:feature)).to be
      end

      it 'returns false because the feature is disabled' do
        Featurer.register :feature, false
        expect(Featurer.on?(:feature)).to_not be
      end

      it 'converts a global feature into a per user one' do
        Featurer.register :feature, true
        Featurer.register :feature, [user_id]

        expect(Featurer.on?(:feature, user_id)).to be
        expect(Featurer.on?(:feature)).to_not be
      end
    end
  end

end
