#!/bin/bash

# SMB Credential Tester
# Tests combinations of usernames and passwords against a Samba share
# Usage: ./smb_test.sh [target_ip]

TARGET="${1:-192.168.1.148}"

# ─────────────────────────────────────────
# Edit these lists with your guesses
# ─────────────────────────────────────────
USERNAMES=(
    "guest"
    "admin"
    "administrator"
    "Admin"
    "rune"
    "Rune"
    "samba"
)

PASSWORDS=(
    ""
    "admin"
    "Admin"
    "password"
    "1234"
    "samba"
    "Rune1234"
    "12dfi93"
    "12dfi93Popintoppen"
    "Popintoppen20"
    "Popintoppen22"
    "Popintoppen23!"
)
# ─────────────────────────────────────────

GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo "================================================"
echo "  SMB Credential Tester"
echo "  Target: $TARGET"
echo "  Usernames: ${#USERNAMES[@]} | Passwords: ${#PASSWORDS[@]}"
echo "  Total combos: $(( ${#USERNAMES[@]} * ${#PASSWORDS[@]} ))"
echo "================================================"
echo ""

FOUND=0

for USER in "${USERNAMES[@]}"; do
    for PASS in "${PASSWORDS[@]}"; do

        DISPLAY_PASS="${PASS:-<empty>}"
        printf "Trying %-20s / %-20s ... " "$USER" "$DISPLAY_PASS"

	OUTPUT=$(smbclient -L "$TARGET" -U "${USER}%${PASS}" 2>&1)
        EXIT_CODE=$?

        # Check for successful share listing
        if echo "$OUTPUT" | grep -qiE "Sharename|disk|ipc\$"; then
            echo -e "${GREEN}SUCCESS!${NC}"
            echo ""
            echo -e "${GREEN}═══ Working credentials found! ═══${NC}"
            echo -e "  Username : ${YELLOW}$USER${NC}"
            echo -e "  Password : ${YELLOW}${DISPLAY_PASS}${NC}"
            echo ""
            echo "Share listing:"
            echo "$OUTPUT"
            echo ""
            FOUND=1
        elif echo "$OUTPUT" | grep -qiE "NT_STATUS_LOGON_FAILURE|NT_STATUS_ACCESS_DENIED"; then
		echo -e "${RED}Failed (failure)${NC} ($OUTPUT)"
        elif echo "$OUTPUT" | grep -qiE "NT_STATUS_CONNECTION_REFUSED|NT_STATUS_HOST_UNREACHABLE|timed out"; then
            echo -e "${RED}Connection error — is the host up?${NC}"
            echo "$OUTPUT"
            exit 1
        else
            echo -e "${RED}Failed${NC} ($OUTPUT)"
        fi

	sleep 0.5
    done
done

echo ""
if [ $FOUND -eq 0 ]; then
    echo -e "${RED}No working credentials found. Add more guesses to the USERNAMES/PASSWORDS lists.${NC}"
else
    echo -e "${GREEN}Done. $FOUND working credential set(s) found.${NC}"
fi
