defmodule MyApp.Password do
  def hash(password) do
    Base.encode16(:crypto.hash(:sha256, password))
  end

  def verify_with_hash(password, hash) do
    hash(password) === hash
  end

  def dummy_verify, do: false
end