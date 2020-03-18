PuppetLint.new_check(:no_hiera) do
  def check
    functions = ['hiera']

    tokens.select { |t| (t.type == :NAME or t.type == :FUNCTION_NAME) and functions.include? t.value }.each do |function_token|
      next unless function_token.next_code_token.type == :LPAREN

      key_token = function_token.next_code_token.next_code_token
      original_function = function_token.value

      notify :error, {
        message: "#{original_function}() function call. Dont do this!",
        line:    key_token.line,
        column:  key_token.column,
      }
    end
  end
end
