//
//  JsonHelper.cpp
//  JsonTest
//
//  Created by gvladislav-52 on 14.02.2026.
//

#include <tao/json.hpp>
#include <string>
#include <vector>
#include <cstring>

extern "C" {

    struct CPerson {
        const char* name;
        int age;
    };

    struct CPersonArray {
        CPerson* people;
        int count;
    };

    struct CPersonArrayHolder {
        std::vector<CPerson> people_storage;
        std::vector<char*> allocated_names;

        ~CPersonArrayHolder() {
            for (char* ptr : allocated_names) {
                delete[] ptr;
            }
        }
    };

    static CPersonArrayHolder g_holder;

    CPersonArray parse_people_from_json(const char* json) {
        g_holder.people_storage.clear();
        g_holder.allocated_names.clear();

        CPersonArray result{};
    
        try {
            auto v = tao::json::from_string(json);

            for (const auto& item : v.get_array()) {
                std::string name = item.at("name").as<std::string>();
                int age = item.at("age").as<int>();

                char* name_c = new char[name.size() + 1];
                std::strcpy(name_c, name.c_str());
                g_holder.allocated_names.push_back(name_c);

                CPerson cPerson;
                cPerson.name = name_c;
                cPerson.age = age;
                g_holder.people_storage.push_back(cPerson);
            }

            result.people = g_holder.people_storage.data();
            result.count = static_cast<int>(g_holder.people_storage.size());
            return result;
        }
        catch (const tao::pegtl::parse_error& e) {
            result.people = nullptr;
            result.count = 0;
            return result;
        }
    }
}
