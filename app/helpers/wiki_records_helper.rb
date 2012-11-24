module WikiRecordsHelper
  def reason_date_row label, date, class_if_exist, class_if_nil
    content, css_class = if date
                           [format_date(date), class_if_exist]
                         else
                           ["None", class_if_nil]
                         end
    content_tag :li, "#{label} #{content}", :class => css_class
  end

  def reason_string_row label, string, class_if_exist, class_if_nil
    content, css_class = if string
                           [string, class_if_exist]
                         else
                           ["None", class_if_nil]
                         end
    content_tag :li, "#{label} #{content}", :class => css_class
  end

  def reason_boolean_row label, value, class_if_true, class_if_false
    content, css_class = value ? ["Yes", class_if_true] : ["No", class_if_false]
    content_tag :li, "#{label} #{content}", :class => css_class
  end

  def format_date date
    if date.year < 1000
      return "#{date.year.abs}#{' B.C.' if date.year < 1}"
    end
    date.strftime "%B %d, %Y"
  end
end
