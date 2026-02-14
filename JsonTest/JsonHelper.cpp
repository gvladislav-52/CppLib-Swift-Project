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

static std::vector<CPerson> people_storage;
static std::vector<char*> allocated_names;

CPersonArray parse_people_from_json(const char* json)
{
    people_storage.clear();
    for (char* ptr : allocated_names) {
        delete[] ptr;
    }
    allocated_names.clear();

    try {
        tao::json::value v = tao::json::from_string(json);

        for (const auto& item : v.get_array()) {
            std::string name = item.at("name").as<std::string>();
            int age = item.at("age").as<int>();

            char* name_c = new char[name.size() + 1];
            std::strcpy(name_c, name.c_str());
            allocated_names.push_back(name_c);

            CPerson cPerson;
            cPerson.name = name_c;
            cPerson.age = age;
            people_storage.push_back(cPerson);
        }

        CPersonArray result;
        result.people = people_storage.data();
        result.count = static_cast<int>(people_storage.size());
        return result;
    }
    catch (...) {
        char* err = new char[14];
        std::strcpy(err, "Parsing error");
        allocated_names.push_back(err);

        CPersonArray errorResult;
        errorResult.people = new CPerson{err, 0};
        errorResult.count = 1;
        return errorResult;
    }
}
}
