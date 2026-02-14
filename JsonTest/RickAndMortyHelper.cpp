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

static std::vector<CCharacter> people_storage;
static std::vector<char*> allocated_names;
static std::vector<char*> allocated_species;
static std::vector<char*> allocated_status;
static std::vector<char*> allocated_images;

CCharacterArray parse_characters_from_json(const char* json)
{
    people_storage.clear();
    for (char* ptr : allocated_names) delete[] ptr;
    for (char* ptr : allocated_species) delete[] ptr;
    for (char* ptr : allocated_status) delete[] ptr;
    for (char* ptr : allocated_images) delete[] ptr;
    allocated_names.clear();
    allocated_species.clear();
    allocated_status.clear();
    allocated_images.clear();

    try {
        tao::json::value v = tao::json::from_string(json);

        for (const auto& item : v.get_array()) {
            std::string name = item.at("name").as<std::string>();
            std::string species = item.at("species").as<std::string>();
            std::string status = item.at("status").as<std::string>();
            std::string image = item.at("imageURL").as<std::string>();
            int id = item.at("id").as<int>();

            char* name_c = new char[name.size() + 1];
            char* species_c = new char[species.size() + 1];
            char* status_c = new char[status.size() + 1];
            char* image_c = new char[image.size() + 1];

            std::strcpy(name_c, name.c_str());
            std::strcpy(species_c, species.c_str());
            std::strcpy(status_c, status.c_str());
            std::strcpy(image_c, image.c_str());

            allocated_names.push_back(name_c);
            allocated_species.push_back(species_c);
            allocated_status.push_back(status_c);
            allocated_images.push_back(image_c);

            CCharacter cChar;
            cChar.name = name_c;
            cChar.species = species_c;
            cChar.status = status_c;
            cChar.imageURL = image_c;
            cChar.id = id;

            people_storage.push_back(cChar);
        }

        CCharacterArray result;
        result.people = people_storage.data();
        result.count = static_cast<int>(people_storage.size());
        return result;
    }
    catch (...) {
        char* err = new char[14];
        std::strcpy(err, "Parsing error");

        allocated_names.push_back(err);
        allocated_species.push_back(err);
        allocated_status.push_back(err);
        allocated_images.push_back(err);

        CCharacterArray errorResult;
        errorResult.people = new CCharacter{err, err, err, err, 0};
        errorResult.count = 1;
        return errorResult;
    }
}
}
