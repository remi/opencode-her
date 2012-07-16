class Hash
  def only(*args); self.reject { |key, value| !args.include?(key.to_sym) }; end
  def not(*args); self.reject { |key, value| args.include?(key.to_sym) }; end
end
