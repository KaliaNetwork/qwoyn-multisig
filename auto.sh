#!/bin/bash

PREPARER=0
PermanentLockedAccount=qwoyn1kgqstc2q0ecze38ugsrfjdek7e8e6y6jc0yux7
BaseAccount=qwoyn12v7ft7dhe4ksg9hws0v5yyjz94uxjgvdudju33
MULTISIG=qwoynd-oversight-multi
selected_validators=("qwoynvaloper1gz26qvhtp4fkjrgperg8944knwu983knnh9kfk" "qwoynvaloper1gtwva9rpnwpeeye7luz2e5h4ea6d2y5xagu2qk" "qwoynvaloper1p64w6kc8f3le84x4jqytugpqxyrcxfqu7xjyp8" "qwoynvaloper1q5yvxp3l8warpl4sxrmzafxw5ammwukhxq60rp")

# Step 0
echo "Who are you? "
echo "1=Kalia Network"
echo "2=KingSuper"
echo "3=CosmicHorizonGuru"
echo "4=StakeCraft"
echo "5=Qwoyn Studios"

while true; do
  read -p "Enter only (1-5): " choice

  case "$choice" in
    1)
      echo "Your choice: Kalia Network"
	  SIGNER=ms-kalianetwork
	  PREPARER=1
      break
      ;;
    2)
      echo "Your choice: KingSuper"
	  SIGNER=KingSuper
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
    5)
      echo "Your choice: Qwoyn Studios"
	  SIGNER=qwoyn_studios_oversight_multi_qwoyn
      break
      ;;
    *)
      echo "Wrong choice! Please enter only between 1-5"
      ;;
  esac
done

if [ "$PREPARER" -eq 1 ]; then

	# Step 1
	for VAL in "${selected_validators[@]}"
	do  
	  qwoynd tx staking delegate "${VAL}" 50000000000uqwoyn --from "${PermanentLockedAccount}" --fees 12500uqwoyn --gas 400000 --generate-only >> "step1_${VAL:12:5}.json"
	done

	# Step 2 - will be upload kalianetwork github
	for VAL in "${selected_validators[@]}"
	do  
	  qwoynd tx authz exec step1_${VAL:12:5}.json --from ${BaseAccount} --fees 12500uqwoyn --gas 400000 --generate-only >> step2_${VAL:12:5}.json
	done

	# Step 3
	for VAL in "${selected_validators[@]}"
	do  
	  qwoynd tx sign step2_${VAL:12:5}.json --multisig ${BaseAccount} --from ${SIGNER} --output-document step3_${VAL:12:5}_${SIGNER}.json
	done

else
  cd && git clone https://github.com/KaliaNetwork/qwoyn-multisig.git && cd qwoyn-multisig

  # Step 3
  for VAL in "${selected_validators[@]}"
  do  
    qwoynd tx sign step2_${VAL:12:5}.json --multisig ${BaseAccount} --from ${SIGNER} --output-document step3_${VAL:12:5}_${SIGNER}.json
  done
	
	
  # Print json results
  for VAL in "${selected_validators[@]}"
  do
    echo "----------------------------------------------------"
    cat step3_${VAL:12:5}_${SIGNER}.json
	echo "----------------------------------------------------"
  done
fi
