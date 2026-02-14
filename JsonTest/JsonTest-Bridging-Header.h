
#ifndef JsonHelper_h
#define JsonHelper_h

#ifdef __cplusplus
extern "C" {
#endif

typedef struct {
    const char* name;
    int age;
} CPerson;

typedef struct {
    CPerson* people;
    int count;
} CPersonArray;


CPersonArray parse_people_from_json(const char* json);

typedef struct {
    const char* name;
    const char* species;
    const char* status;
    const char* imageURL;
    int id;
} CCharacter;

typedef struct {
    CCharacter* people;
    int count;
} CCharacterArray;

CCharacterArray parse_characters_from_json(const char* json);

#ifdef __cplusplus
}
#endif

#endif
