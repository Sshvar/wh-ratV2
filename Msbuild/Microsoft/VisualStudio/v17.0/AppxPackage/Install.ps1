﻿#
# This script just calls the Add-AppDevPackage.ps1 script that lives next to it.
#

param(
    [switch]$Force = $false,
    [switch]$SkipLoggingTelemetry = $false
)

$scriptArgs = ""
if ($Force)
{
    $scriptArgs = '-Force'
}

if ($SkipLoggingTelemetry)
{
    if ($Force)
    {
        $scriptArgs += ' '
    }

    $scriptArgs += '-SkipLoggingTelemetry'
}

try
{
    # Log telemetry data regarding the use of the script if possible.
    # There are three ways that this can be disabled:
    #   1. If the "TelemetryDependencies" folder isn't present.  This can be excluded at build time by setting the MSBuild property AppxLogTelemetryFromSideloadingScript to false
    #   2. If the SkipLoggingTelemetry switch is passed to this script.
    #   3. If Visual Studio telemetry is disabled via the registry.
    $TelemetryAssembliesFolder = (Join-Path $PSScriptRoot "TelemetryDependencies")
    if (!$SkipLoggingTelemetry -And (Test-Path $TelemetryAssembliesFolder))
    {
        $job = Start-Job -FilePath (Join-Path $TelemetryAssembliesFolder "LogSideloadingTelemetry.ps1") -ArgumentList $TelemetryAssembliesFolder, "VS/DesignTools/SideLoadingScript/Install", $null, $null
        Wait-Job -Job $job -Timeout 60 | Out-Null
    }
}
catch
{
    # Ignore telemetry errors
}

$currLocation = Get-Location
Set-Location $PSScriptRoot
Invoke-Expression ".\Add-AppDevPackage.ps1 $scriptArgs"
Set-Location $currLocation
# SIG # Begin signature block
# MIIhdwYJKoZIhvcNAQcCoIIhaDCCIWQCAQExDzANBglghkgBZQMEAgEFADB5Bgor
# BgEEAYI3AgEEoGswaTA0BgorBgEEAYI3AgEeMCYCAwEAAAQQH8w7YFlLCE63JNLG
# KX7zUQIBAAIBAAIBAAIBAAIBADAxMA0GCWCGSAFlAwQCAQUABCC7kxV/l3biwCGH
# VuAKUAkPVeCZ2LSQIMJf+ROzV3B37KCCC3IwggT6MIID4qADAgECAhMzAAAD3o1W
# glrxpKlnAAAAAAPeMA0GCSqGSIb3DQEBCwUAMH4xCzAJBgNVBAYTAlVTMRMwEQYD
# VQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRtb25kMR4wHAYDVQQKExVNaWNy
# b3NvZnQgQ29ycG9yYXRpb24xKDAmBgNVBAMTH01pY3Jvc29mdCBDb2RlIFNpZ25p
# bmcgUENBIDIwMTAwHhcNMjAxMjE1MjEyNDIwWhcNMjExMjAyMjEyNDIwWjB0MQsw
# CQYDVQQGEwJVUzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMHUmVkbW9u
# ZDEeMBwGA1UEChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMR4wHAYDVQQDExVNaWNy
# b3NvZnQgQ29ycG9yYXRpb24wggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIB
# AQCn8/DiSdIkSLNe/aikoxkWIAtCq9W+7+dbEXN/cZ4ZkeX/mn8MPRJVyt7FaE3k
# bFofDl4GH5xZOQoOUhGh8mfq3sUq9RDZ6T1vFanVTeRq3iamvmjYHVgYq1MW9RdY
# 1UaGH7OE2L0coGjp46azVnYJlj7I1BWMZXxYRSxGQttNi9g1lwXCGfGl+aTqWSfy
# hRpMB/mpVC4IF8MYsHVYctYb1ex+3ZwDSmwsX/Y4sxtSpt18xX9Rso2fES8GGnQK
# dBnMMdySgdp0E4ACWpa0iQDTBQMQVSTfrVFjyetviHoMejI+SgbkiPrEezGGvTiG
# Ooc6+eWSEwYMy9sxw0GaCiVvAgMBAAGjggF5MIIBdTAfBgNVHSUEGDAWBgorBgEE
# AYI3PQYBBggrBgEFBQcDAzAdBgNVHQ4EFgQUJOo70fFaruzlxG7u+R2Hd9N1TIkw
# UAYDVR0RBEkwR6RFMEMxKTAnBgNVBAsTIE1pY3Jvc29mdCBPcGVyYXRpb25zIFB1
# ZXJ0byBSaWNvMRYwFAYDVQQFEw0yMzA4NjUrNDYzMTMzMB8GA1UdIwQYMBaAFOb8
# X3u7IgBY5HJOtfQhdCMy5u+sMFYGA1UdHwRPME0wS6BJoEeGRWh0dHA6Ly9jcmwu
# bWljcm9zb2Z0LmNvbS9wa2kvY3JsL3Byb2R1Y3RzL01pY0NvZFNpZ1BDQV8yMDEw
# LTA3LTA2LmNybDBaBggrBgEFBQcBAQROMEwwSgYIKwYBBQUHMAKGPmh0dHA6Ly93
# d3cubWljcm9zb2Z0LmNvbS9wa2kvY2VydHMvTWljQ29kU2lnUENBXzIwMTAtMDct
# MDYuY3J0MAwGA1UdEwEB/wQCMAAwDQYJKoZIhvcNAQELBQADggEBADxf8A60TSfr
# Xa5t5G1ExJ08OpjCi9RBsN8T+wkozcz1E0QfB8mxaE38u00S89z+HoCJ5/LCgMBY
# VoTWAHtbG4PYT7rLcGzBuX8S+OIlBR2LtghZ5H6mCiblpD/3dMz2d2Z62/TCYAHp
# 0iKlHa+EJ/KW7SPsvfUNxQ2IbolvXfQGuTyFV9HEN/NdfmWWg78vXVZ25TlM1HLj
# uotGgyG7Td3b4cHQBZbO+XVZ/AITsfAB6TlqFzGCLINYyZ90EX0sAcm6mVvO2GDU
# PiqJjKoh+0nO06ccETCeyMMRxt6oyJB+0UkldpKX4aZc18u0gNohHGx04bp9Jc6D
# TuTh3ynE8hwwggZwMIIEWKADAgECAgphDFJMAAAAAAADMA0GCSqGSIb3DQEBCwUA
# MIGIMQswCQYDVQQGEwJVUzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMH
# UmVkbW9uZDEeMBwGA1UEChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMTIwMAYDVQQD
# EylNaWNyb3NvZnQgUm9vdCBDZXJ0aWZpY2F0ZSBBdXRob3JpdHkgMjAxMDAeFw0x
# MDA3MDYyMDQwMTdaFw0yNTA3MDYyMDUwMTdaMH4xCzAJBgNVBAYTAlVTMRMwEQYD
# VQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRtb25kMR4wHAYDVQQKExVNaWNy
# b3NvZnQgQ29ycG9yYXRpb24xKDAmBgNVBAMTH01pY3Jvc29mdCBDb2RlIFNpZ25p
# bmcgUENBIDIwMTAwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQDpDmRQ
# eWe1xOP9CQBMnpSs91Zo6kTYz8VYT6mldnxtRbrTOZK0pB75+WWC5BfSj/1EnAjo
# ZZPOLFWEv30I4y4rqEErGLeiS25JTGsVB97R0sKJHnGUzbV/S7SvCNjMiNZrF5Q6
# k84mP+zm/jSYV9UdXUn2siou1YW7WT/4kLQrg3TKK7M7RuPwRknBF2ZUyRy9HcRV
# Yldy+Ge5JSA03l2mpZVeqyiAzdWynuUDtWPTshTIwciKJgpZfwfs/w7tgBI1TBKm
# vlJb9aba4IsLSHfWhUfVELnG6Krui2otBVxgxrQqW5wjHF9F4xoUHm83yxkzgGqJ
# TaNqZmN4k9Uwz5UfAgMBAAGjggHjMIIB3zAQBgkrBgEEAYI3FQEEAwIBADAdBgNV
# HQ4EFgQU5vxfe7siAFjkck619CF0IzLm76wwGQYJKwYBBAGCNxQCBAweCgBTAHUA
# YgBDAEEwCwYDVR0PBAQDAgGGMA8GA1UdEwEB/wQFMAMBAf8wHwYDVR0jBBgwFoAU
# 1fZWy4/oolxiaNE9lJBb186aGMQwVgYDVR0fBE8wTTBLoEmgR4ZFaHR0cDovL2Ny
# bC5taWNyb3NvZnQuY29tL3BraS9jcmwvcHJvZHVjdHMvTWljUm9vQ2VyQXV0XzIw
# MTAtMDYtMjMuY3JsMFoGCCsGAQUFBwEBBE4wTDBKBggrBgEFBQcwAoY+aHR0cDov
# L3d3dy5taWNyb3NvZnQuY29tL3BraS9jZXJ0cy9NaWNSb29DZXJBdXRfMjAxMC0w
# Ni0yMy5jcnQwgZ0GA1UdIASBlTCBkjCBjwYJKwYBBAGCNy4DMIGBMD0GCCsGAQUF
# BwIBFjFodHRwOi8vd3d3Lm1pY3Jvc29mdC5jb20vUEtJL2RvY3MvQ1BTL2RlZmF1
# bHQuaHRtMEAGCCsGAQUFBwICMDQeMiAdAEwAZQBnAGEAbABfAFAAbwBsAGkAYwB5
# AF8AUwB0AGEAdABlAG0AZQBuAHQALiAdMA0GCSqGSIb3DQEBCwUAA4ICAQAadO9X
# Tyl7xBaFeLhQ0yL8CZ2sgpf4NP8qLJeVEuXkv8+/k8jjNKnbgbjcHgC+0jVvr+V/
# eZV35QLU8evYzU4eG2GiwlojGvCMqGJRRWcI4z88HpP4MIUXyDlAptcOsyEp5aWh
# aYwik8x0mOehR0PyU6zADzBpf/7SJSBtb2HT3wfV2XIALGmGdj1R26Y5SMk3YW0H
# 3VMZy6fWYcK/4oOrD+Brm5XWfShRsIlKUaSabMi3H0oaDmmp19zBftFJcKq2rbty
# R2MX+qbWoqaG7KgQRJtjtrJpiQbHRoZ6GD/oxR0h1Xv5AiMtxUHLvx1MyBbvsZx/
# /CJLSYpuFeOmf3Zb0VN5kYWd1dLbPXM18zyuVLJSR2rAqhOV0o4R2plnXjKM+zeF
# 0dx1hZyHxlpXhcK/3Q2PjJst67TuzyfTtV5p+qQWBAGnJGdzz01Ptt4FVpd69+lS
# TfR3BU+FxtgL8Y7tQgnRDXbjI1Z4IiY2vsqxjG6qHeSF2kczYo+kyZEzX3EeQK+Y
# Zcki6EIhJYocLWDZN4lBiSoWD9dhPJRoYFLv1keZoIBA7hWBdz6c4FMYGlAdOJWb
# HmYzEyc5F3iHNs5Ow1+y9T1HU7bg5dsLYT0q15IszjdaPkBCMaQfEAjCVpy/JF1R
# Ap1qedIX09rBlI4HeyVxRKsGaubUxt8jmpZ1xTGCFVswghVXAgEBMIGVMH4xCzAJ
# BgNVBAYTAlVTMRMwEQYDVQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRtb25k
# MR4wHAYDVQQKExVNaWNyb3NvZnQgQ29ycG9yYXRpb24xKDAmBgNVBAMTH01pY3Jv
# c29mdCBDb2RlIFNpZ25pbmcgUENBIDIwMTACEzMAAAPejVaCWvGkqWcAAAAAA94w
# DQYJYIZIAWUDBAIBBQCgga4wGQYJKoZIhvcNAQkDMQwGCisGAQQBgjcCAQQwHAYK
# KwYBBAGCNwIBCzEOMAwGCisGAQQBgjcCARUwLwYJKoZIhvcNAQkEMSIEILnmx/DL
# sme4EXSNG1kZGesXMcnWcLyJHy2/07NYyjrlMEIGCisGAQQBgjcCAQwxNDAyoBSA
# EgBNAGkAYwByAG8AcwBvAGYAdKEagBhodHRwOi8vd3d3Lm1pY3Jvc29mdC5jb20w
# DQYJKoZIhvcNAQEBBQAEggEAliy5Xflg0gc2+bFVkRrRPHCOyZzptblstBMClPgb
# yDocUlaxsxhhrRxAZ3VxCWgmaO5ST1DxIXBNoFYqRKOf0hbCLPxbCaJ14MUVmN2w
# Ts5okJTM2o88uwa2iZ7du3lj8HQbOUSyM8bQINAKl99P2Kp2audZXP5VlQJlW4cI
# rOgs7TX/ze0Ib0SDiA1qoJlrpC2iyYiF+eimc5vsCuD2uTeiO9m985KBRJ3AcqUU
# akv8PS/K4/9pTz+XMR9VUk2g7KNESOizF6vCF8rGxbuZ9VbvMBFwYc5Pu+rp6Tq1
# LscMLl5juNnpc/Otq8pNr+gGFJS1V0OG/2oruTMNEgMZKaGCEuUwghLhBgorBgEE
# AYI3AwMBMYIS0TCCEs0GCSqGSIb3DQEHAqCCEr4wghK6AgEDMQ8wDQYJYIZIAWUD
# BAIBBQAwggFRBgsqhkiG9w0BCRABBKCCAUAEggE8MIIBOAIBAQYKKwYBBAGEWQoD
# ATAxMA0GCWCGSAFlAwQCAQUABCA/mD9E/Sz0ioy3aBqrBsXZ4NGDHVIKTcxshyv2
# zLLJPgIGYWoegpPAGBMyMDIxMTAyMzAyMTA0Mi40MzJaMASAAgH0oIHQpIHNMIHK
# MQswCQYDVQQGEwJVUzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMHUmVk
# bW9uZDEeMBwGA1UEChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMSUwIwYDVQQLExxN
# aWNyb3NvZnQgQW1lcmljYSBPcGVyYXRpb25zMSYwJAYDVQQLEx1UaGFsZXMgVFNT
# IEVTTjpBRTJDLUUzMkItMUFGQzElMCMGA1UEAxMcTWljcm9zb2Z0IFRpbWUtU3Rh
# bXAgU2VydmljZaCCDjwwggTxMIID2aADAgECAhMzAAABSKKIRVa8L4C/AAAAAAFI
# MA0GCSqGSIb3DQEBCwUAMHwxCzAJBgNVBAYTAlVTMRMwEQYDVQQIEwpXYXNoaW5n
# dG9uMRAwDgYDVQQHEwdSZWRtb25kMR4wHAYDVQQKExVNaWNyb3NvZnQgQ29ycG9y
# YXRpb24xJjAkBgNVBAMTHU1pY3Jvc29mdCBUaW1lLVN0YW1wIFBDQSAyMDEwMB4X
# DTIwMTExMjE4MjU1NloXDTIyMDIxMTE4MjU1NlowgcoxCzAJBgNVBAYTAlVTMRMw
# EQYDVQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRtb25kMR4wHAYDVQQKExVN
# aWNyb3NvZnQgQ29ycG9yYXRpb24xJTAjBgNVBAsTHE1pY3Jvc29mdCBBbWVyaWNh
# IE9wZXJhdGlvbnMxJjAkBgNVBAsTHVRoYWxlcyBUU1MgRVNOOkFFMkMtRTMyQi0x
# QUZDMSUwIwYDVQQDExxNaWNyb3NvZnQgVGltZS1TdGFtcCBTZXJ2aWNlMIIBIjAN
# BgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA9/94rxWEitHRrXF2mfKTSxAEW62i
# XsK8ovyYG2ipau4YRSFNRJGNBzIhUZtv1rLpLetpNuc7w8Vten6YYOfO+vpdcGJw
# pYHv6xZa0dlLtVsLRZnNcRqcuPrsaGwhDHiBQxoS+QzU22zorC6wVGG8l6+3z88W
# 1ZBMCQz+RRtp9K6Najo3oCJCyI11OqmoXbkMU37DzhKfI4KjCp/vn6R+n71ypXsF
# s3bH74YmeB+CKtQkzp/n5ManA8Ex2JGGWIKpvtV9ce+OfK6evaoxXlT9xmwLyW2N
# 2xZaubssa4j3GcQ2awen9cAC16ztvyHX1RHcE1qiSA2QSY08nEIYcUt4tQIDAQAB
# o4IBGzCCARcwHQYDVR0OBBYEFIcy8GmfDgS0SR9LPROt6SHFiaJHMB8GA1UdIwQY
# MBaAFNVjOlyKMZDzQ3t8RhvFM2hahW1VMFYGA1UdHwRPME0wS6BJoEeGRWh0dHA6
# Ly9jcmwubWljcm9zb2Z0LmNvbS9wa2kvY3JsL3Byb2R1Y3RzL01pY1RpbVN0YVBD
# QV8yMDEwLTA3LTAxLmNybDBaBggrBgEFBQcBAQROMEwwSgYIKwYBBQUHMAKGPmh0
# dHA6Ly93d3cubWljcm9zb2Z0LmNvbS9wa2kvY2VydHMvTWljVGltU3RhUENBXzIw
# MTAtMDctMDEuY3J0MAwGA1UdEwEB/wQCMAAwEwYDVR0lBAwwCgYIKwYBBQUHAwgw
# DQYJKoZIhvcNAQELBQADggEBAGYSlsGzJwvUMsHK5YLNKl/W4cYmRr3vvCRA9u4T
# oshmvEfZ6sx4OPqujSn2F30utrjFCadrvie7SDVE3/9boC/iuEcLD1XoQ2rEiSY/
# u26CMWT/AFP8UHVWO6oJkBpneBfnOYZCSbZejUXmBPdPEOvfKo9Zg6a9DMfuC4T/
# 7U6i+h6WRFEZYRTnXZ8i0rVQhXXzSNchhz/Z9MjdSn4RhFd7OzAc6RSV8Dn5cIMh
# PXMEPI4zk1aTUXQqi/z+VYggKNnXIh43dbtYtUOEGesW9PgdR3WRURCzohcH9LId
# 2dcTnkhXB4NKyxPq7Hh8+EIb6BI+4fWw/FTe/x5wg8FqQSUwggZxMIIEWaADAgEC
# AgphCYEqAAAAAAACMA0GCSqGSIb3DQEBCwUAMIGIMQswCQYDVQQGEwJVUzETMBEG
# A1UECBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMHUmVkbW9uZDEeMBwGA1UEChMVTWlj
# cm9zb2Z0IENvcnBvcmF0aW9uMTIwMAYDVQQDEylNaWNyb3NvZnQgUm9vdCBDZXJ0
# aWZpY2F0ZSBBdXRob3JpdHkgMjAxMDAeFw0xMDA3MDEyMTM2NTVaFw0yNTA3MDEy
# MTQ2NTVaMHwxCzAJBgNVBAYTAlVTMRMwEQYDVQQIEwpXYXNoaW5ndG9uMRAwDgYD
# VQQHEwdSZWRtb25kMR4wHAYDVQQKExVNaWNyb3NvZnQgQ29ycG9yYXRpb24xJjAk
# BgNVBAMTHU1pY3Jvc29mdCBUaW1lLVN0YW1wIFBDQSAyMDEwMIIBIjANBgkqhkiG
# 9w0BAQEFAAOCAQ8AMIIBCgKCAQEAqR0NvHcRijog7PwTl/X6f2mUa3RUENWlCgCC
# hfvtfGhLLF/Fw+Vhwna3PmYrW/AVUycEMR9BGxqVHc4JE458YTBZsTBED/FgiIRU
# QwzXTbg4CLNC3ZOs1nMwVyaCo0UN0Or1R4HNvyRgMlhgRvJYR4YyhB50YWeRX4FU
# sc+TTJLBxKZd0WETbijGGvmGgLvfYfxGwScdJGcSchohiq9LZIlQYrFd/XcfPfBX
# day9ikJNQFHRD5wGPmd/9WbAA5ZEfu/QS/1u5ZrKsajyeioKMfDaTgaRtogINeh4
# HLDpmc085y9Euqf03GS9pAHBIAmTeM38vMDJRF1eFpwBBU8iTQIDAQABo4IB5jCC
# AeIwEAYJKwYBBAGCNxUBBAMCAQAwHQYDVR0OBBYEFNVjOlyKMZDzQ3t8RhvFM2ha
# hW1VMBkGCSsGAQQBgjcUAgQMHgoAUwB1AGIAQwBBMAsGA1UdDwQEAwIBhjAPBgNV
# HRMBAf8EBTADAQH/MB8GA1UdIwQYMBaAFNX2VsuP6KJcYmjRPZSQW9fOmhjEMFYG
# A1UdHwRPME0wS6BJoEeGRWh0dHA6Ly9jcmwubWljcm9zb2Z0LmNvbS9wa2kvY3Js
# L3Byb2R1Y3RzL01pY1Jvb0NlckF1dF8yMDEwLTA2LTIzLmNybDBaBggrBgEFBQcB
# AQROMEwwSgYIKwYBBQUHMAKGPmh0dHA6Ly93d3cubWljcm9zb2Z0LmNvbS9wa2kv
# Y2VydHMvTWljUm9vQ2VyQXV0XzIwMTAtMDYtMjMuY3J0MIGgBgNVHSABAf8EgZUw
# gZIwgY8GCSsGAQQBgjcuAzCBgTA9BggrBgEFBQcCARYxaHR0cDovL3d3dy5taWNy
# b3NvZnQuY29tL1BLSS9kb2NzL0NQUy9kZWZhdWx0Lmh0bTBABggrBgEFBQcCAjA0
# HjIgHQBMAGUAZwBhAGwAXwBQAG8AbABpAGMAeQBfAFMAdABhAHQAZQBtAGUAbgB0
# AC4gHTANBgkqhkiG9w0BAQsFAAOCAgEAB+aIUQ3ixuCYP4FxAz2do6Ehb7Prpsz1
# Mb7PBeKp/vpXbRkws8LFZslq3/Xn8Hi9x6ieJeP5vO1rVFcIK1GCRBL7uVOMzPRg
# Eop2zEBAQZvcXBf/XPleFzWYJFZLdO9CEMivv3/Gf/I3fVo/HPKZeUqRUgCvOA8X
# 9S95gWXZqbVr5MfO9sp6AG9LMEQkIjzP7QOllo9ZKby2/QThcJ8ySif9Va8v/rbl
# jjO7Yl+a21dA6fHOmWaQjP9qYn/dxUoLkSbiOewZSnFjnXshbcOco6I8+n99lmqQ
# eKZt0uGc+R38ONiU9MalCpaGpL2eGq4EQoO4tYCbIjggtSXlZOz39L9+Y1klD3ou
# OVd2onGqBooPiRa6YacRy5rYDkeagMXQzafQ732D8OE7cQnfXXSYIghh2rBQHm+9
# 8eEA3+cxB6STOvdlR3jo+KhIq/fecn5ha293qYHLpwmsObvsxsvYgrRyzR30uIUB
# HoD7G4kqVDmyW9rIDVWZeodzOwjmmC3qjeAzLhIp9cAvVCch98isTtoouLGp25ay
# p0Kiyc8ZQU3ghvkqmqMRZjDTu3QyS99je/WZii8bxyGvWbWu3EQ8l1Bx16HSxVXj
# ad5XwdHeMMD9zOZN+w2/XU/pnR4ZOC+8z1gFLu8NoFA12u8JJxzVs341Hgi62jbb
# 01+P3nSISRKhggLOMIICNwIBATCB+KGB0KSBzTCByjELMAkGA1UEBhMCVVMxEzAR
# BgNVBAgTCldhc2hpbmd0b24xEDAOBgNVBAcTB1JlZG1vbmQxHjAcBgNVBAoTFU1p
# Y3Jvc29mdCBDb3Jwb3JhdGlvbjElMCMGA1UECxMcTWljcm9zb2Z0IEFtZXJpY2Eg
# T3BlcmF0aW9uczEmMCQGA1UECxMdVGhhbGVzIFRTUyBFU046QUUyQy1FMzJCLTFB
# RkMxJTAjBgNVBAMTHE1pY3Jvc29mdCBUaW1lLVN0YW1wIFNlcnZpY2WiIwoBATAH
# BgUrDgMCGgMVAIcrgpa6HFn+EiHEWnwBF9UYbOs5oIGDMIGApH4wfDELMAkGA1UE
# BhMCVVMxEzARBgNVBAgTCldhc2hpbmd0b24xEDAOBgNVBAcTB1JlZG1vbmQxHjAc
# BgNVBAoTFU1pY3Jvc29mdCBDb3Jwb3JhdGlvbjEmMCQGA1UEAxMdTWljcm9zb2Z0
# IFRpbWUtU3RhbXAgUENBIDIwMTAwDQYJKoZIhvcNAQEFBQACBQDlHdcoMCIYDzIw
# MjExMDIzMDgzNDQ4WhgPMjAyMTEwMjQwODM0NDhaMHcwPQYKKwYBBAGEWQoEATEv
# MC0wCgIFAOUd1ygCAQAwCgIBAAICFswCAf8wBwIBAAICEhUwCgIFAOUfKKgCAQAw
# NgYKKwYBBAGEWQoEAjEoMCYwDAYKKwYBBAGEWQoDAqAKMAgCAQACAwehIKEKMAgC
# AQACAwGGoDANBgkqhkiG9w0BAQUFAAOBgQCFXEvM8/uuN1CC+jrhkYOprjRMDRwj
# 1zQPAg6yZXfYXGW0XvR6p59Jwr6A8NOiySeT+PaiWi35DSL5xak0Y525szDz6bfk
# N2rv4Ht30AJygTIUzqw+RafZkJkeLusKI2RUFoixEaLjYypUXiD58HEqDMdtSdK8
# DaggDvQLtOiUAzGCAw0wggMJAgEBMIGTMHwxCzAJBgNVBAYTAlVTMRMwEQYDVQQI
# EwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRtb25kMR4wHAYDVQQKExVNaWNyb3Nv
# ZnQgQ29ycG9yYXRpb24xJjAkBgNVBAMTHU1pY3Jvc29mdCBUaW1lLVN0YW1wIFBD
# QSAyMDEwAhMzAAABSKKIRVa8L4C/AAAAAAFIMA0GCWCGSAFlAwQCAQUAoIIBSjAa
# BgkqhkiG9w0BCQMxDQYLKoZIhvcNAQkQAQQwLwYJKoZIhvcNAQkEMSIEIBDIkP2U
# DDFho53RcpTgVaphT2nD1KKsHxocx7y7TlwdMIH6BgsqhkiG9w0BCRACLzGB6jCB
# 5zCB5DCBvQQgqZAa6ox5ob8mH+bU3E7w+WOGvle/U8FVek9WgMHbaNgwgZgwgYCk
# fjB8MQswCQYDVQQGEwJVUzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMH
# UmVkbW9uZDEeMBwGA1UEChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMSYwJAYDVQQD
# Ex1NaWNyb3NvZnQgVGltZS1TdGFtcCBQQ0EgMjAxMAITMwAAAUiiiEVWvC+AvwAA
# AAABSDAiBCB7wU0dWrWimR4Z/ZuW1GwjYx8Sf047gO6MBgx/5zbENjANBgkqhkiG
# 9w0BAQsFAASCAQCk/4hyp78qHwtBYR96FaT4Fs8PAH/xs7j3rEE8vrTkweVz3wqf
# JAS3HkR/UXw8eFq7TYIDZell3PHcq20wboeEJEJLaAJSqS0aKTV/ck/ba3IsEyqS
# wwXyttTGg3Ph72Cc4WlnJSQF57NX0EdUZWnViyQ1AbmNZwTEhG9+aC8WzO+tvCem
# OR8JLFWWu8dmYLZlsGr6bShv/Z8NkhHIvMs2zJBUO/5todLfxsuJRh9BQ0CJUj2d
# /CAnFpTSA0o0CwtyNxCjUvw2ZA6+ZfpRShMbH+NO2unOcse3ztbk3xXEdWpL7k59
# 7GwoFkxinXBhzOlVwBYrsBJX5oKUlGVdpa99
# SIG # End signature block
