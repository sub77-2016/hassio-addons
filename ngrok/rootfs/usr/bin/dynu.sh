#!/usr/bin/with-contenv bashio
set -e
bashio::log.debug "Update dynu..."
configPath="/ngrok-config/ngrok.yml"

configfile=$(cat $configPath)
bashio::log.debug "Config file: \n${configfile}"
bashio::log.info "Updating dynu..."

public_url=$(curl -s http://localhost:4040/api/tunnels/hass | cut -d"," -f3 | cut -b 14- | sed -e 's/^"//' -e 's/"$//')
bashio::log.info "Public URL $public_url"

curl -s -X POST "https://api.dynu.com/v2/dns/$(bashio::config 'dynu_id')/webRedirect/$(bashio::config 'dynu_webredirectid')" -H  "accept: application/json" -H  "API-Key: $(bashio::config 'dynu_token')" -H  "Content-Type: application/json" -d "{\"nodeName\":\"\",\"redirectType\":\"UF\",\"state\":true,\"url\":\"$public_url\",\"cloak\":false,\"includeQueryString\":true,\"title\":\"\",\"metaKeywords\":\"\",\"metaDescription\":\"\"}" >/dev/null
