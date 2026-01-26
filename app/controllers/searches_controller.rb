class SearchesController < ApplicationController
  def index
    @query = params[:query]
    @scope = params[:scope].presence || 'all'

    @scope_options = [
      ['Everywhere', 'all'],
      ['Just questions', 'questions'],
      ['Only answers', 'answers'],
      ['Comments only', 'comments'],
      ['Users only', 'users']
    ]

    return @results = [] if @query.blank?

    if @scope != 'all'
      @results = search_in_scope(@scope, @query)
    else
      @results = PgSearch.multisearch(@query)
    end
  end

  private

  def search_in_scope(scope, query)
    case scope
    when 'questions'
      Question.search_by_title_and_body(query)
    when 'answers'
      PgSearch.multisearch(query).where(searchable_type: 'Answer')
    when 'comments'
      PgSearch.multisearch(query).where(searchable_type: 'Comment')
    when 'users'
      User.search_by_email(query)
    else
      PgSearch.multisearch(query)
    end
  end
end
