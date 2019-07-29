#!/bin/bash

pod trunk push IdentitySdkCore.podspec  --allow-warnings
pod trunk push IdentitySdkWebView.podspec
pod trunk push IdentitySdkFacebook.podspec
pod trunk push IdentitySdkGoogle.podspec
