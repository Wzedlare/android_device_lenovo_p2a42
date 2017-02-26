#
# Copyright (C) 2016 The CyanogenMod Project
#               2017 The LineageOS Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# Inherit from those products. Most specific first.
$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/full_base_telephony.mk)

# Inherit from p2a42 device
$(call inherit-product, device/lenovo/p2a42/device.mk)

# Inherit some common Lineage  stuff.
$(call inherit-product, vendor/cm/config/common_full_phone.mk)

# Device identifier. This must come after all inclusions.
PRODUCT_NAME := cm_p2a42
PRODUCT_DEVICE := p2a42
PRODUCT_BRAND := Lenovo
PRODUCT_MODEL := Lenovo P2
PRODUCT_MANUFACTURER := Lenovo

PRODUCT_GMS_CLIENTID_BASE := android-lenovo

PRODUCT_BUILD_PROP_OVERRIDES += \
    BUILD_FINGERPRINT=Lenovo/p2a42/p2a42:6.0.1/MMB29M/V8.1.3.0.MBECNDI:user/release-keys \
    PRIVATE_BUILD_DESC="p2a42-user 6.0.1 MMB29M V8.1.3.0.MBECNDI release-keys"

TARGET_VENDOR := Lenovo
TARGET_VENDOR_PRODUCT_NAME := p2a42
