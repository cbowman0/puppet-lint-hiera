PuppetLint.new_check(:lookup) do
  def check
    functions = ['lookup']

    lookups_in_parameters = []
    parent_class = ''
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
      next unless function_token.next_code_token.type == :LPAREN and !is_profile
      next if lookups_in_parameters.include? function_token and is_profile

      key_token = function_token.next_code_token.next_code_token
      lookup_key_token = function_token.prev_code_token.prev_code_token

      notify :error, {
        message: "#{function_token.value}() function call found in class. Only use in class params.",
        line:    key_token.line,
        column:  key_token.column,
      }
    end
  end
end
