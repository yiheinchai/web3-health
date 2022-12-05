pragma solidity ^0.4.0;

contract HealthcareContract {

    // Define a struct to store information about a patient
    struct Patient {
        string firstName;
        string lastName;
        uint age;
        string gender;
        string[] medicalConditions;
        string[] medications;
        string[] allergies;
    }

    // Define a mapping to store the patients
    mapping (address => Patient) public patients;

    // Define an event to be triggered when a patient is added
    event PatientAdded(address patientAddress);

    // The constructor is called when the contract is deployed
    // It sets the initial values of the variables
    function HealthcareContract() {
        // Add some initial patients
        addPatient("John", "Doe", 30, "Male", ["Hypertension", "Diabetes"], ["Lisinopril", "Metformin"], ["Peanuts"]);
        addPatient("Jane", "Doe", 28, "Female", ["Asthma"], ["Albuterol"], ["Latex"]);
    }

    // This function allows a patient to add their information to the contract
    function addPatient(string firstName, string lastName, uint age, string gender, string[] medicalConditions, string[] medications, string[] allergies) {
        // Create a new patient
        Patient memory newPatient = Patient({
            firstName: firstName,
            lastName: lastName,
            age: age,
            gender: gender,
            medicalConditions: medicalConditions,
            medications: medications,
            allergies: allergies
        });

        // Add the patient to the mapping
        patients[msg.sender] = newPatient;

        // Trigger the PatientAdded event
        PatientAdded(msg.sender);
    }

    // This function allows a doctor to access a patient's information
    function getPatientInfo(address patientAddress) public view returns (string, string, uint, string, string[], string[], string[]) {
        // Get the patient
        Patient memory patient = patients[patientAddress];

        // Return the patient's information
        return (patient.first);
        
        // Update the patient's information in the mapping
        patients[patientAddress] = patient;
    }
}