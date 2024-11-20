PuppetLint.new_check(:lookup_in_class_params) do
  def check
    functions = ['lookup']

    lookups_in_parameters = []
    class_indexes.each do |class_idx|
      # return early if no params
      next if class_idx[:param_tokens].nil?

      # iterate over each parameter token
      class_idx[:param_tokens].each do |p_token|
        lookups_in_parameters << p_token if ((p_token.type == :NAME or p_token.type == :FUNCTION_NAME) and functions.include? p_token.value)
      end

      tokens.select { |t| (t.type == :NAME or t.type == :FUNCTION_NAME) and functions.include? t.value }.each do |function_token|
        is_profile = class_idx[:name_token].value.match(/^profile::.*/)
        #is_profile = parent_class_name.match(/^profile::.*/)
        in_params = lookups_in_parameters.include? function_token
        next unless function_token.next_code_token.type == :LPAREN
        next if is_profile
        next unless in_params

        key_token = function_token.next_code_token.next_code_token

        error_message = "#{function_token.value}() function call found in class params."

        notify :error, {
          message: error_message,
          line:    key_token.line,
          column:  key_token.column,
        }
      end
    end
  end
end
