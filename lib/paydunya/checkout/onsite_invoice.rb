module Paydunya
  module Onsite
    class Invoice < Paydunya::Checkout::Invoice

      attr_accessor :invoice_token

      def initialize
        super
      end

      def charge(opr_token,confirm_token)
        payload = {
          :token => opr_token,
          :confirm_token => confirm_token
        }

        result = http_json_request(Paydunya::Setup.opr_charge_base_url,payload)

        if result["response_code"] == "00"
          rebuild_invoice(result["invoice_data"])
          @response_code = result["response_code"]
          @response_text = result["response_text"]
          true
        else
          @response_code = result["response_code"]
          @response_text = result["response_text"]
          false
        end
      end

      def create(account_alias)

        payload = {
          :invoice_data => build_invoice_payload,
          :opr_data => {
            :account_alias => account_alias
          }
        }

        result = http_json_request(Paydunya::Setup.opr_base_url,payload)
        create_response(result)
      end

    end
  end
end