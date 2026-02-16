//
//  RickAndMortyHelper.cpp
//  JsonTest
//
//  Created by gvladislav-52 on 14.02.2026.
//

#include <tao/json.hpp>
#include <string>
#include <vector>
#include <cstring>

extern "C" {

    struct CCharacter {
        const char* name;
        const char* species;
        const char* status;
        const char* imageURL;
        int id;
    };

    struct CCharacterArray {
        CCharacter* people;
        int count;
    };

    struct CCharacterArrayHolder {
        std::vector<CCharacter> people_storage;
        std::vector<char*> allocated_strings;

        ~CCharacterArrayHolder() {
            for (char* ptr : allocated_strings) {
                delete[] ptr;
            }
        }
    };

    static CCharacterArrayHolder g_holder;

CCharacterArray parse_characters_from_json(const char* json) {
    g_holder.people_storage.clear();
    g_holder.allocated_strings.clear();

    CCharacterArray result{};

    try {
        auto v = tao::json::from_string(json);

        const auto& results = v.at("results").get_array();

        for (const auto& item : results) {
            std::string name    = item.at("name").as<std::string>();
            std::string species = item.at("species").as<std::string>();
            std::string status  = item.at("status").as<std::string>();
            std::string image   = item.at("image").as<std::string>();
            int id = item.at("id").as<int>();

            auto allocate_string = [&](const std::string& str) -> char* {
                char* cstr = new char[str.size() + 1];
                std::strcpy(cstr, str.c_str());
                g_holder.allocated_strings.push_back(cstr);
                return cstr;
            };

            CCharacter cChar;
            cChar.name     = allocate_string(name);
            cChar.species  = allocate_string(species);
            cChar.status   = allocate_string(status);
            cChar.imageURL = allocate_string(image);
            cChar.id       = id;

            g_holder.people_storage.push_back(cChar);
        }

        result.people = g_holder.people_storage.data();
        result.count = static_cast<int>(g_holder.people_storage.size());
        return result;

    } catch (const tao::pegtl::parse_error&) {
        result.people = nullptr;
        result.count = 0;
        return result;
    } catch (const std::exception&) {
        result.people = nullptr;
        result.count = 0;
        return result;
    }
}

}
