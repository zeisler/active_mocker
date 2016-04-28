# frozen_string_literal: true
module StripHeredoc
  refine String do
    def strip_heredoc
      indent = scan(/^[ \t]*(?=\S)/).min.size || 0
      gsub(/^[ \t]{#{indent}}/, "")
    end
  end
end
