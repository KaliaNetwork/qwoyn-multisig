#!/bin/bash

PREPARER=0
PermanentLockedAccount=qwoyn1kgqstc2q0ecze38ugsrfjdek7e8e6y6jc0yux7
TO_1=qwoyn1crh8ud7xf58grjv697xwm0ee37cpzr33z2n3jw
TO_2=qwoyn1svv64nwrglw0fxkzj0uss36csdneaqw9ut9cwq
TO_3=qwoyn18jkq8aws4e53qanhyrxjstdzmp7hee6jxa05ew
BaseAccount=qwoyn1pk6fz7zepllfa3fjzcfl05zzmzsvw3yma0q62k
MULTISIG=oversight-multisig

# Step 0
echo "Who are you? "
echo "1=Kalia Network"
echo "2=Qwoyn Studios"
echo "3=CosmicHorizonGuru"
echo "4=StakeCraft"

while true; do
  read -p "Enter only (1-4): " choice

  case "$choice" in
    1)
      echo "Your choice: Kalia Network"
	  SIGNER=ms-kalianetwork
	  PREPARER=1
      break
      ;;
    2)
      echo "Your choice: Qwoyn Studios"
	  SIGNER=qwoyn_studios_oversight_multi_qwoyn
      break
      ;;
    3)
      echo "Your choice: CosmicHorizonGuru"
	  SIGNER=cosmichorizonguru
      break
      ;;
    4)
      echo "Your choice: StakeCraft"
	  SIGNER=stakecraft-multisig-qw
      break
      ;;
    *)
      echo "Wrong choice! Please enter only between 1-4"
      ;;
  esac
done

if [ "$PREPARER" -eq 1 ]; then

	# Step 1
	qwoynd tx bank multi-send ${PermanentLockedAccount} ${TO_1} ${TO_2} ${TO_3} 2140000000uqwoyn --from "${PermanentLockedAccount}" --gas-prices 0.0025uqwoyn --gas-adjustment 1.3 --generate-only >> "step1_send.json"
	
	# Step 2 - will be upload kalianetwork github
	qwoynd tx authz exec step1_send.json --from ${BaseAccount} --gas-prices 0.0025uqwoyn --gas-adjustment 1.3 --generate-only >> step2_send.json
	
	# Step 3
	qwoynd tx sign step2_send.json --multisig ${BaseAccount} --from ${SIGNER} --output-document step3_send_${SIGNER}.json
	
else
  cd && git clone https://github.com/KaliaNetwork/qwoyn-multisig.git && cd qwoyn-multisig

  # Step 3
  qwoynd tx sign step2_send.json --multisig ${BaseAccount} --from ${SIGNER} --output-document step3_send_${SIGNER}.json
  	
  # Print json results
  echo "----------------------------------------------------"
  echo step3_send_${SIGNER}.json
  echo ""
  cat step3_send_${SIGNER}.json
  echo "----------------------------------------------------"
fi
