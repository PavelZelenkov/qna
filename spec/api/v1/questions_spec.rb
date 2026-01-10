require 'rails_helper'

describe 'Questions API' do
  let(:headers) { { "ACCEPT" => "application/json" } }

  describe 'GET /api/v1/questions' do
    let(:api_path) { '/api/v1/questions' }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:questions) { create_list(:question, 2) }
      let(:question) { questions.first }
      let(:question_response) { json['questions'].first }
      let!(:answers) { create_list(:answer, 3, question: question) }

      before do
        get '/api/v1/questions', params: { access_token: access_token.token }, headers: headers
      end

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns list of questions' do
        expect(json['questions'].size).to eq 2
      end

      it 'returns all public fields' do
        %w[id title body created_at updated_at].each do |attr|
          expect(question_response[attr]).to eq question.send(attr).as_json
        end
      end

      it 'contains short title' do
        expect(question_response['short_title']).to eq question.title.truncate(7)
      end
    end
  end

  describe 'GET /api/v1/questions/:id' do
    let(:question) { create(:question) }
    let(:api_path) { "/api/v1/questions/#{question.id}" }
  
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
        %w[id title body created_at updated_at].each do |attr|
          expect(json['question'][attr]).to eq question.send(attr).as_json
        end
      end
  
      it 'contains author object' do
        expect(json['question']['author']['id']).to eq question.author.id
      end
  
      it 'contains short title' do
        expect(json['question']['short_title']).to eq question.title.truncate(7)
      end
  
      it 'contains files urls' do
        urls = json['question']['files']
        expect(urls).to match_array question.files.map { |f|
          Rails.application.routes.url_helpers.rails_blob_url(f, only_path: true)
        }
      end
  
      it 'contains links array' do
        expect(json['question']['links']).to be_a(Array)
      end
  
      it 'contains comments' do
        comments = json['question']['comments']
        expect(comments.size).to eq question.comments.size
      end
    end
  end

  describe 'POST /api/v1/questions' do
    let(:api_path) { '/api/v1/questions' }
  
    it_behaves_like 'API Authorizable' do
      let(:method) { :post }
    end
  
    context 'authorized' do
      let(:access_token) { create(:access_token) }
  
      context 'with valid params' do
        let(:valid_params) do
          { question: attributes_for(:question),
            access_token: access_token.token }
        end
  
        it 'returns 201 status' do
          post api_path, params: valid_params, headers: headers
          expect(response).to have_http_status :created
        end
  
        it 'creates question in db' do
          expect {
            post api_path, params: valid_params, headers: headers
          }.to change(Question, :count).by(1)
        end
  
        it 'returns question with correct fields' do
          post api_path, params: valid_params, headers: headers
          %w[title body].each do |attr|
            expect(json['question'][attr]).to eq valid_params[:question][attr.to_sym]
          end
        end
      end
  
      context 'with invalid params' do
        let(:invalid_params) do
          { question: attributes_for(:question, :invalid),
            access_token: access_token.token }
        end
  
        it 'does not create question' do
          expect {
            post api_path, params: invalid_params, headers: headers
          }.to_not change(Question, :count)
        end
  
        it 'returns 422 status' do
          post api_path, params: invalid_params, headers: headers
          expect(response).to have_http_status :unprocessable_entity
        end
      end
    end
  end

  describe 'PATCH /api/v1/questions/:id' do
    let(:question) { create(:question) }
    let(:api_path) { "/api/v1/questions/#{question.id}" }
  
    it_behaves_like 'API Authorizable' do
      let(:method) { :patch }
    end
  
    context 'authorized' do
      let(:access_token) { create(:access_token, resource_owner_id: question.author.id) }
  
      context 'with valid params' do
        let(:new_title) { 'New title' }
  
        before do
          patch api_path, params: {
            access_token: access_token.token,
            question: { title: new_title }
          }, headers: headers
        end
  
        it 'returns 200 status' do
          expect(response).to be_successful
        end
  
        it 'changes question attributes' do
          question.reload
          expect(question.title).to eq new_title
        end
      end
  
      context 'with invalid params' do
        before do
          patch api_path, params: {
            access_token: access_token.token,
            question: { title: '' }
          }, headers: headers
        end
  
        it 'does not change question' do
          expect(question.reload.title).to_not eq ''
        end
  
        it 'returns 422 status' do
          expect(response).to have_http_status :unprocessable_entity
        end
      end
    end
  end

  describe 'DELETE /api/v1/questions/:id' do
    let!(:question) { create(:question) }
    let(:api_path) { "/api/v1/questions/#{question.id}" }
  
    it_behaves_like 'API Authorizable' do
      let(:method) { :delete }
    end
  
    context 'authorized' do
      let(:access_token) { create(:access_token, resource_owner_id: question.author.id) }
  
      it 'deletes question from db' do
        expect {
          delete api_path,
                 params: { access_token: access_token.token },
                 headers: headers
        }.to change(Question, :count).by(-1)
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
