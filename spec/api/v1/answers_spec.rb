require 'rails_helper'

describe 'Answers API' do
  let(:headers) { { 'ACCEPT' => 'application/json' } }

  describe 'GET /api/v1/questions/:question_id/answers' do
    let(:question) { create(:question) }
    let!(:answers) { create_list(:answer, 3, question: question) }
    let(:api_path) { "/api/v1/questions/#{question.id}/answers" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }

      before do
        get api_path, params: { access_token: access_token.token }, headers: headers
      end

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns list of answers' do
        expect(json['answers'].size).to eq 3
      end

      it 'returns all public fields' do
        answer_response = json['answers'].first
        answer = answers.first

        %w[id body created_at updated_at].each do |attr|
          expect(answer_response[attr]).to eq answer.send(attr).as_json
        end
      end
    end
  end

  describe 'GET /api/v1/answers/:id' do
    let(:answer) { create(:answer) }
    let(:api_path) { "/api/v1/answers/#{answer.id}" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }

      before do
        get api_path, params: { access_token: access_token.token }, headers: headers
      end

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns all public fields' do
        %w[id body created_at updated_at].each do |attr|
          expect(json['answer'][attr]).to eq answer.send(attr).as_json
        end
      end

      it 'contains author object' do
        expect(json['answer']['author']['id']).to eq answer.author.id
      end

      it 'contains question object' do
        expect(json['answer']['question']['id']).to eq answer.question.id
      end
    end
  end

  describe 'POST /api/v1/questions/:question_id/answers' do
    let(:question) { create(:question) }
    let(:api_path) { "/api/v1/questions/#{question.id}/answers" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :post }
    end

    context 'authorized' do
      let(:me) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }

      context 'with valid params' do
        let(:valid_params) do
          {
            answer: attributes_for(:answer),
            access_token: access_token.token
          }
        end

        it 'creates answer in db' do
          expect {
            post api_path, params: valid_params, headers: headers
          }.to change(question.answers, :count).by(1)
        end

        it 'returns 201 status' do
          post api_path, params: valid_params, headers: headers
          expect(response).to have_http_status :created
        end

        it 'sets current user as author' do
          post api_path, params: valid_params, headers: headers
          expect(json['answer']['author']['id']).to eq me.id
        end
      end

      context 'with invalid params' do
        let(:invalid_params) do
          {
            answer: attributes_for(:answer, :invalid),
            access_token: access_token.token
          }
        end

        it 'does not create answer' do
          expect {
            post api_path, params: invalid_params, headers: headers
          }.not_to change(Answer, :count)
        end

        it 'returns 422 status' do
          post api_path, params: invalid_params, headers: headers
          expect(response).to have_http_status :unprocessable_entity
        end
      end
    end
  end

  describe 'PATCH /api/v1/answers/:id' do
    let(:me) { create(:user) }
    let!(:answer) { create(:answer, author: me) }
    let(:api_path) { "/api/v1/answers/#{answer.id}" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :patch }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }

      context 'with valid params' do
        before do
          patch api_path,
                params: { access_token: access_token.token,
                          answer: { body: 'New body' } },
                headers: headers
        end

        it 'returns 200 status' do
          expect(response).to be_successful
        end

        it 'changes answer body' do
          expect(answer.reload.body).to eq 'New body'
        end
      end

      context 'with invalid params' do
        before do
          patch api_path,
                params: { access_token: access_token.token,
                          answer: { body: '' } },
                headers: headers
        end

        it 'does not change answer' do
          expect(answer.reload.body).to_not eq ''
        end

        it 'returns 422 status' do
          expect(response).to have_http_status :unprocessable_entity
        end
      end
    end
  end

  describe 'DELETE /api/v1/answers/:id' do
    let(:me) { create(:user) }
    let!(:answer) { create(:answer, author: me) }
    let(:api_path) { "/api/v1/answers/#{answer.id}" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :delete }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }

      it 'deletes answer from db' do
        expect {
          delete api_path,
                 params: { access_token: access_token.token },
                 headers: headers
        }.to change(Answer, :count).by(-1)
      end

      it 'returns 204 status' do
        delete api_path,
               params: { access_token: access_token.token },
               headers: headers
        expect(response).to have_http_status :no_content
      end
    end
  end
end
