PuppetLint.new_check(:lookup) do
  def check
    functions = ['lookup']

    lookups_in_parameters = Array.new
    parent_class = String.new
    class_indexes.each do |class_idx|
      parent_class = class_idx[:name_token]
      # return early if no params
      next if class_idx[:param_tokens].nil?

      # iterate over each parameter token
      class_idx[:param_tokens].each do |p_token|
        lookups_in_parameters << p_token if ((p_token.type == :NAME or p_token.type == :FUNCTION_NAME) and functions.include? p_token.value)
      end
    end

    tokens.select { |t| (t.type == :NAME or t.type == :FUNCTION_NAME) and functions.include? t.value }.each do |function_token|
      parent_class_name = parent_class.value
      is_profile = parent_class_name.match(/^profile::.*/)
      in_params = lookups_in_parameters.include? function_token
      next unless function_token.next_code_token.type == :LPAREN
      next if in_params && is_profile

      key_token = function_token.next_code_token.next_code_token
      lookup_key_token = function_token.prev_code_token.prev_code_token

      error_message = "#{function_token.value}() function call found in"
      if in_params && !is_profile
        error_message = error_message + " class params."
      elsif is_profile && !in_params
        error_message = error_message + " profile class. Only use in profile params."
      else
        error_message = error_message + " class."
      end

      notify :error, {
#        message: "#{function_token.value}() function call found in class. Only use in class params.",
        message: error_message,
        line:    key_token.line,
        column:  key_token.column,
      }
    end
  end
end
