defmodule TicketingWeb.CertApiJSON do

  @public_key """
  -----BEGIN PUBLIC KEY-----
  MIICIjANBgkqhkiG9w0BAQEFAAOCAg8AMIICCgKCAgEAr2oyPq2wjwYMzzEtn3oY
  5ocylj1KsRuuGeqx6XTqzVwUhfVVnwlTrXCZDthLheTChah87BSXXxlvrHhPNW8Y
  qGoxYohgiVcg69lG5FoTOe01V9M1SOwcwtMAcg5+7Zf6+1KAdrsUFgC8d7bIaOE8
  7GDt+LJdB6R7gZeV4u20xxqpNZc5lRD6s3oxFJyuPhhd5OPVUOaXNj6bVpBSNNqe
  qrWwMZ87t1VgAMOeUFmcrALVRU/D/FlBWFLsYn3sgub3Xb0HXwR1Xci3nYckVpZa
  MUqNs7UcgMOT+SX734So+EGZbW8FMPDuQtteRj/oZRYafTiAtodGQ719hrIBvgLZ
  AYJB4Cm3boYDv/92C42Ms63ePRy7kKipeB15QPCgvEBfAUGaxxa/0CfQ9oGk8VP8
  ywg2oMRlmybxZSv/jVMt2fSkWtyfNpROjkpGCzx/Rq35966vISb/tWQTBWJC9pTP
  LM6qWrarFl6gKxlzhWM90wXMBy/bs/9LxtrVFeM+yPFBvnTp8zQSxEGAj8B5bmma
  gQUm6snfBXBh5aq3yEeEgPDG8iIirM0PTmyEDQ98A6EzxV4Svng31vXLdHZCPoFE
  bIDkM3SuNpNs8tFk9PUo/x43/aXMsu37bSWYmKUZgKoVjlg1//rcM1VNUu2k7Kb4
  NFBcrFMkKEkT6AlSitkjJyUCAwEAAQ==
  -----END PUBLIC KEY-----
  """

  def key(_t) do
    %{public_key: @public_key}
  end

  def message(_t) do
    token_config = %{} # empty config
    token_config = Map.put(token_config, "hello", %Joken.Claim{
      generate: fn -> "world" end,
    })
    signer = Joken.Signer.parse_config(:my_rsa_key)
    {:ok, claims} = Joken.generate_claims(token_config)
    {:ok, jwt, _claims} = Joken.encode_and_sign(claims, signer)
    %{jwt: jwt}
  end
end
