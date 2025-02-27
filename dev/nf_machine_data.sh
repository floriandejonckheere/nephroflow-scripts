nf_function nf_machine_data dev "Send machine data to the API"
function nf_machine_data() {
  if [[ ${SHELL} != "/bin/zsh" ]]; then
    echo "Error: This function requires Zsh"

    return 1
  fi

  if [[ ! ${1} ]]; then
    echo "Usage: ${0} [machine_id=nipro_surdial_x] [serial_number=4A0312620B59] [device_id=bd0e842c-4866-676d-ec84-89da3f2707c2] [patient_id=1234567890] parameter_name=parameter_value..."

    return 1
  fi

  if [[ ! ${ACCESS_TOKEN} ]]; then
    echo "Error: ACCESS_TOKEN not set"

    return 1
  fi

  unset PARAMETERS
  declare -A PARAMETERS

  # Parse argument separated by equals sign
  for ARGUMENT in "${@}"; do
    KEY=$(echo "${ARGUMENT}" | cut -d= -f1)
    VALUE=$(echo "${ARGUMENT}" | cut -d= -f2)

    PARAMETERS[${KEY}]="${VALUE}"
  done

  # Extract essential information
  MACHINE_ID=${PARAMETERS[machine_id]:-"nipro_surdial_x"}
  DEVICE_ID=${PARAMETERS[link_id]:-"bd0e842c-4866-676d-ec84-89da3f2707c2"}
  SERIAL_NUMBER=${PARAMETERS[serial_number]:-"4A0312620B59"}
  PATIENT_ID=${PARAMETERS[patient_id]:-"1234567890"}

  # Convert remaining parameters into JSON
  unset 'PARAMETERS[machine_id]'
  unset 'PARAMETERS[serial_number]'

  PARAMETERS=$(for KEY VALUE in ${(kv)PARAMETERS}; do
    echo "{\"name\": \"${KEY}\",\"value\": \"${VALUE}\"}"
  done | paste -sd "," -)

  DATA="{\"timestamp\":\"$(date -u)\",\"device_id\":\"${DEVICE_ID}\",\"machine_id\":\"${MACHINE_ID}\",\"serial_number\":\"${SERIAL_NUMBER}\",\"patient_id\":\"${PATIENT_ID}\",\"parameters\":[${PARAMETERS}]}"

  nf_post command/IntegrateMachineData "${DATA}"
}
