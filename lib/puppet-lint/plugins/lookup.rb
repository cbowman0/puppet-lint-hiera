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
      next unless function_token.next_code_token.type == :LPAREN
      next if lookups_in_parameters.include? function_token

      key_token = function_token.next_code_token.next_code_token
      lookup_key_token = function_token.prev_code_token.prev_code_token

      notify :error, {
        message: "#{function_token.value}() function call. Dont do this!",
        line:    key_token.line,
        column:  key_token.column,
      }
    end
  end
end
