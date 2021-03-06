module ApplicationHelper
  def transparency_class
    if controller_name == 'articles' and action_name == 'index'
      ''
    else
      'transparent'
    end
  end

  def tag_cloud(tags, classes)
    max = tags.sort_by(&:count).last
    tags.each do |tag|
      index = tag.count.to_f / max.count * (classes.size - 1)
      yield(tag, classes[index.round])
    end
  end

  def markdown(text)
    # renderer = Redcarpet::Render::HTML.new
    renderer = Pygmentizer
    options = {
      filter_html: false,
      hard_wrap: true,
      autolink: true,
      no_intra_emphasis: true,
      fenced_code_blocks: true,
      lax_html_blocks: true,
      strikethrough: true,
      superscript: true,
      tables: true
    }
    Redcarpet::Markdown.new(renderer, options).render(text).html_safe
  end

  def syntax_highlighter(html)  
    doc = Nokogiri::HTML(html)  
    doc.search("//code[@class]").each do |code|  
      code.replace Pygments.highlight(code.text, lexer: code[:class])  
    end  
    doc.to_s  
  end  
end
