/*
 Copyright (C) 2017 - 2022 The Android Open Source Project
 SPDX-License-Identifier: Apache-2.0
*/

#include <stdio.h>
#include <stdlib.h>
#include <fcntl.h>
#include <unistd.h>
#include <android-base/properties.h>
#include <android-base/logging.h>
#include <sys/resource.h>
#define _REALLY_INCLUDE_SYS__SYSTEM_PROPERTIES_H_
#include <sys/_system_properties.h>

using android::base::GetProperty;

void property_override(const std::string& name, const std::string& value)
{
    size_t valuelen = value.size();

    prop_info* pi = (prop_info*) __system_property_find(name.c_str());
    if (pi != nullptr) {
        __system_property_update(pi, value.c_str(), valuelen);
    }
    else {
        int rc = __system_property_add(name.c_str(), name.size(), value.c_str(), valuelen);
        if (rc < 0) {
            LOG(ERROR) << "property_set(\"" << name << "\", \"" << value << "\") failed: "
                       << "__system_property_add failed";
        }
    }
}

void model_property_override(const std::string& device, const std::string& name, const std::string& model)
{
    property_override("ro.product.device", device);
    property_override("ro.product.board", device);
    property_override("ro.product.brand", "Redmi");
    property_override("ro.product.manufacturer", "Xiaomi");
    property_override("ro.product.odm.brand", "Redmi");
    property_override("ro.product.odm.manufacturer", "Xiaomi");
    property_override("ro.product.odm.device", device);
    property_override("ro.product.system.brand", "Redmi");
    property_override("ro.product.system.manufacturer", "Xiaomi");
    property_override("ro.product.system.device", device);
    property_override("ro.product.vendor.brand", "Redmi");
    property_override("ro.product.vendor.manufacturer", "Xiaomi");
    property_override("ro.product.vendor.device", device);
    property_override("ro.build.product", device);
    property_override("ro.product.odm.name", device);
    property_override("ro.product.product.device", device);
    property_override("ro.product.product.brand", "Redmi");
    property_override("ro.product.product.manufacturer", "Xiaomi");
    property_override("ro.product.product.name", device);
    property_override("ro.product.system.name", device);
    property_override("ro.product.system_ext.device", device);
    property_override("ro.product.system_ext.brand", "Redmi");
    property_override("ro.product.system_ext.manufacturer", "Xiaomi");
    property_override("ro.product.system_ext.name", device);
    property_override("ro.product.vendor.name", device);
    property_override("ro.product.model", model);
    property_override("ro.product.odm.model", name);
    property_override("ro.product.system.model", name);
    property_override("ro.product.vendor.model", name);
    property_override("ro.product.product.model", name);
    property_override("ro.product.system_ext.model", name);
}

void vendor_load_properties() {
    property_override("ro.product.name", "tornado");
    property_override("ro.bootimage.build.date.utc", "1780931795");
    property_override("ro.build.date.utc", "1780931795");
    const std::string sku = GetProperty("ro.boot.product.hardware.sku", "");
    if (sku == "stone_p") {
        model_property_override("tornado", "2508CRN2BI", "REDMI 15C 5G");
    } else {
        model_property_override("tornado", "2508CRN2BI", "REDMI 15C 5G");
    }
}
