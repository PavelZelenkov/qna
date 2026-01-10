require 'rails_helper'

describe 'Profiles API' do
  let(:headers) { { "ACCEPT" => "application/json" } }

  describe 'GET /api/v1/profiles/me' do
    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
      let(:api_path) { '/api/v1/profiles/me' }
    end

    context 'authorized' do
      let(:me) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }

      before do
        get '/api/v1/profiles/me', params: { access_token: access_token.token }, headers: headers
      end

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns all public fields' do
        %w[id email admin created_at updated_at].each do |attr|
          expect(json['user'][attr]).to eq me.send(attr).as_json
        end
      end

      it 'does not return private fields' do
        %w[password encrypted_password].each do |attr|
          expect(json).to_not have_key(attr)
        end
      end
    end
  end

  describe 'GET /api/v1/profiles' do
    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
      let(:api_path) { '/api/v1/profiles' }
    end

    context 'authorized' do
      let(:me) { create(:user) }
      let!(:others) { create_list(:user, 3) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }

      before do
        get '/api/v1/profiles', params: { access_token: access_token.token }, headers: headers
      end

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'does not contain current user' do
        ids = json['users'].map { |u| u['id'] }
        expect(ids).to_not include me.id
      end

      it 'returns all other users' do
        ids = json['users'].map { |u| u['id'] }
        expect(ids).to match_array others.map(&:id)
      end

      it 'returns public fields of each user' do
        %w[id email created_at updated_at].each do |attr|
          json['users'].each_with_index do |user_json, index|
            expect(user_json[attr]).to eq others[index].send(attr).as_json
          end
        end
      end

      it 'does not return private fields of each user' do
        %w[password encrypted_password].each do |attr|
          json['users'].each do |user_json|
            expect(user_json).to_not have_key(attr)
          end
        end
      end
    end
  end
end
