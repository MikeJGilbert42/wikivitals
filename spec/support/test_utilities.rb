def mock_get_article_body page_name
  file_name = "#{page_name}.raw"
  body = nil
  begin
    file = File.open Rails.root.join("test_data", "#{file_name}")
  rescue Exception => e
    raise "Problem opening test data file #{file_name}"
  end

  begin
    body = IO.read file
  rescue Exception => e
    raise "Problem reading test data file #{file_name}"
  end
  body
end
