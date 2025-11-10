class AnswerBroadcastSerializer
  def initialize(answer, view_context:)
    @answer = answer
    @view = view_context
  end

  def as_json
    {
      id: @answer.id,
      body: @answer.body,
      rating: @answer.votes.sum(:value),
      best: @answer.best?,
      author_id: @answer.author_id,
      question_author_id: @answer.question.author_id,
      links: @answer.links.map { |l|
        {
          id: l.id, name: l.name, url: l.url,
          gist: l.gist?,
          gist_height: l.gist? ? (20 + 20 * gist_line_count(l.url)) : nil
        }
      },
      files: @answer.files.map { |f|
        { id: f.id, name: f.filename.to_s, url: @view.url_for(f) }
      },
      comments_section_html: @view.formats.include?(:html) ? @view.render(
        partial: "answers/comments_section_only_list",
        locals: { answer: @answer }
      ) : nil
    }
  end

  private

  def gist_line_count(url)
    10
  end
end
