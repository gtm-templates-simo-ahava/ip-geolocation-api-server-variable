___TERMS_OF_SERVICE___

By creating or modifying this file you agree to Google Tag Manager's Community
Template Gallery Developer Terms of Service available at
https://developers.google.com/tag-manager/gallery-tos (or such other URL as
Google may provide), as modified from time to time.


___INFO___

{
  "type": "MACRO",
  "id": "cvt_temp_public_id",
  "version": 1,
  "securityGroups": [],
  "displayName": "IP Geolocation API",
  "categories": ["UTILITY"],
  "description": "Unofficial template for resolving metadata (e.g. geolocation) for an IP address. Utilizes the https://ipgeolocation.io API.",
  "containerContexts": [
    "SERVER"
  ]
}


___TEMPLATE_PARAMETERS___

[
  {
    "type": "TEXT",
    "name": "apiKey",
    "displayName": "API Key",
    "simpleValueType": true,
    "valueValidators": [
      {
        "type": "NON_EMPTY"
      }
    ],
    "help": "Enter the API key from your \u003ca href\u003d\"https://ipgeolocation.io\"\u003eipgeolocation.io\u003c/a\u003e account."
  },
  {
    "type": "CHECKBOX",
    "name": "ipFromRequest",
    "checkboxText": "Use IP address from incoming HTTP request",
    "simpleValueType": true,
    "defaultValue": true,
    "help": "Check this box to utilize the IP address from the incoming HTTP request. This would be the IP address of the user / machine that sent the request to the GTM server."
  },
  {
    "type": "TEXT",
    "name": "customIp",
    "displayName": "Custom IP address",
    "simpleValueType": true,
    "valueValidators": [
      {
        "type": "NON_EMPTY"
      }
    ],
    "enablingConditions": [
      {
        "paramName": "ipFromRequest",
        "paramValue": false,
        "type": "EQUALS"
      }
    ],
    "help": "Enter the IP address (IPv4 or IPv6) you want to resolve the metadata for."
  },
  {
    "type": "CHECKBOX",
    "name": "fullJson",
    "checkboxText": "Retrieve full JSON response",
    "simpleValueType": true,
    "defaultValue": false,
    "help": "Check this box to have the variable retrieve the full JSON object from the IP Geolocation service."
  },
  {
    "type": "TEXT",
    "name": "fieldToFetch",
    "displayName": "Response field",
    "simpleValueType": true,
    "valueHint": "e.g. latitude",
    "valueValidators": [
      {
        "type": "NON_EMPTY"
      }
    ],
    "help": "Enter a single field name to fetch from the IP Geolocation API response. The full list of available fields is \u003ca href\u003d\"https://ipgeolocation.io/documentation/ip-geolocation-api.html\"\u003ehere\u003c/a\u003e.",
    "enablingConditions": [
      {
        "paramName": "fullJson",
        "paramValue": false,
        "type": "EQUALS"
      }
    ]
  }
]


___SANDBOXED_JS_FOR_SERVER___

const getRemoteAddress = require('getRemoteAddress');
const JSON = require('JSON');
const sendHttpGet = require('sendHttpGet');

const HTTP_URL = 'https://api.ipgeolocation.io/ipgeo';
const ipAddress = data.ipFromRequest ? getRemoteAddress() : data.customIp;

let getURL = HTTP_URL + '?apiKey=' + data.apiKey + '&ip=' + ipAddress;

if (!data.fullJson) getURL += '&fields=' + data.fieldToFetch;

return sendHttpGet(getURL).then(result => {
  const body = JSON.parse(result.body);
  return data.fullJson ? body : body[data.fieldToFetch];
});


___SERVER_PERMISSIONS___

[
  {
    "instance": {
      "key": {
        "publicId": "send_http",
        "versionId": "1"
      },
      "param": [
        {
          "key": "allowedUrls",
          "value": {
            "type": 1,
            "string": "specific"
          }
        },
        {
          "key": "urls",
          "value": {
            "type": 2,
            "listItem": [
              {
                "type": 1,
                "string": "https://api.ipgeolocation.io/ipgeo?*"
              }
            ]
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  },
  {
    "instance": {
      "key": {
        "publicId": "read_request",
        "versionId": "1"
      },
      "param": [
        {
          "key": "requestAccess",
          "value": {
            "type": 1,
            "string": "any"
          }
        },
        {
          "key": "headerAccess",
          "value": {
            "type": 1,
            "string": "any"
          }
        },
        {
          "key": "queryParameterAccess",
          "value": {
            "type": 1,
            "string": "any"
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  }
]


___TESTS___

scenarios: []


___NOTES___

Created on 25/04/2022, 12:10:37


