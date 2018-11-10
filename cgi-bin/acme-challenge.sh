#!/bin/sh
printf 'Content-type: text/plain\r\n'
printf '\r\n'

# as listed by acme.sh --register-account
ACCOUNT_THUMBPRINT='1_ppTFrlX-eFkEMpepzbOEg_Oeml9kC6cWnehmLKBUY'

printf '%s.%s\r\n' "${QUERY_STRING}" "${ACCOUNT_THUMBPRINT}"
