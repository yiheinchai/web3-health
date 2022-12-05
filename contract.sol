pragma solidity ^0.4.0;

import "https://github.com/OpenZeppelin/openzeppelin-solidity/contracts/math/SafeMath.sol";

contract HealthcareContract {

    using SafeMath for uint;

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

    // Define an event to be triggered when a patient's information is updated
    event PatientUpdated(address patientAddress);

    // The constructor is called when the contract is deployed
    // It sets the initial values of the variables
    function HealthcareContract() {
        // Add some initial patients
        addPatient("John", "Doe", 30, "Male", ["Hypertension", "Diabetes"], ["Lisinopril", "Metformin"], ["Peanuts"]);
        addPatient("Jane", "Doe", 28, "Female", ["Asthma"], ["Albuterol"], ["Latex"]);
    }

    // This function allows a patient to add their information to the contract
    function addPatient(string firstName, string lastName, uint age, string gender, string[] medicalConditions, string[] medications, string[] allergies) {
        // Check if the patient's address is already in the mapping
        if (patients[msg.sender].age > 0) {
            // If the patient's address is already in the mapping, do not add the patient again
        } else {
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
    }

    // This function allows a doctor to access a patient's information
    function getPatientInfo(address patientAddress) public view returns (string, string, uint, string, string[], string[], string[]) {
        // Get the patient
        Patient memory patient = patients[patientAddress];

        // Return the patient's information
        return (patient.firstName, patient.lastName, patient.age, patient.gender, patient.medicalConditions, patient.medications, patient.allergies);
    }

    // This function allows a doctor to update a patient's information
    function updatePatientInfo(address patientAddress, string firstName, string lastName, uint age, string gender, string[] medicalConditions, string[] medications, string[] allergies) public {
        // Get the patient
        Patient memory patient = patients[patientAddress];

        // Update the patient's information
        patient.firstName = firstName;
        patient.lastName = lastName;
        patient.age = age;
        patient.gender = gender;
        patient.medicalConditions = medicalConditions;
        patient.medications = medications;
        patient.allergies = allergies;

        // Update the patient's information in the mapping
        patients[patientAddress] = patient;

        // Trigger the PatientUpdated event
        PatientUpdated(patientAddress);
    }

       // This function allows a doctor to prescribe a medication to a patient
    function prescribeMedication(address patientAddress, string medication) public {
        // Get the patient
        Patient memory patient = patients[patientAddress];

        // Add the medication to the patient's list of medications
        patient.medications.push(medication);

        // Update the patient's information in the mapping
        patients[patientAddress] = patient;

        // Trigger the PatientUpdated event
        PatientUpdated(patientAddress);

        // Send a notification to the patient about the prescribed medication
        // (Note: This implementation is for demonstration purposes only. In a real-world scenario,
        // the contract would need to be integrated with an external service, such as an email or SMS provider,
        // to send the notification to the patient)
        sendMedicationNotification(patientAddress, medication);
    }

    // This function sends a notification to the patient about the prescribed medication
    function sendMedicationNotification(address patientAddress, string medication) private {
        // Construct the notification message
        string memory message = "Dear " + patients[patientAddress].firstName + ",\n\n";
        message += "You have been prescribed the following medication: " + medication + "\n\n";
        message += "Please contact your doctor for more information and instructions on how to take the medication.\n\n";
        message += "Best regards,\n";
        message += "Your healthcare provider";

        // Send the notification to the patient
        // (Note: In a real-world scenario, the contract would need to be integrated with an external service,
        // such as an email or SMS provider, to actually send the notification to the patient.
        // For demonstration purposes, we will simply log the notification message to the console)
        console.log(message);
    }

        // This function allows a doctor to access a patient's list of allergies
    function getPatientAllergies(address patientAddress) public view returns (string[]) {
        // Get the patient
        Patient memory patient = patients[patientAddress];

        // Return the patient's list of allergies
        return patient.allergies;
    }

        // Define a struct to store information about a message
    struct Message {
        address sender;
        string message;
        bool isRead;
    }

    // Define a mapping to store the messages
    mapping (address => Message[]) public messages;

    // Define an event to be triggered when a message is sent
    event MessageSent(address patientAddress);

    // This function allows a patient to send a message to their doctor
    function sendMessage(string message) public {
        // Create a new message
        Message memory newMessage = Message({
            sender: msg.sender,
            message: message,
            isRead: false
        });

        // Add the message to the mapping
        messages[msg.sender].push(newMessage);

        // Trigger the MessageSent event
        MessageSent(msg.sender);
    }

    // This function allows a doctor to access the messages sent by their patients
    function getPatientMessages(address patientAddress) public view returns (address[], string[], bool[]) {
        // Get the messages for the patient
        Message[] memory patientMessages = messages[patientAddress];

        // Define arrays to store the message sender, message, and read status
        address[] memory senderArray = new address[](patientMessages.length);
        string[] memory messageArray = new string[](patientMessages.length);
        bool[] memory isReadArray = new bool[](patientMessages.length);

        // Loop through the messages and store the sender, message, and read status in the arrays
        for (uint i = 0; i < patientMessages.length; i++) {
            senderArray[i] = patientMessages[i].sender;
            messageArray[i] = patientMessages[i].message;
            isReadArray[i] = patientMessages[i].isRead;
        }

        // Return the arrays of sender, message, and read status
        return (senderArray, messageArray, isReadArray);
    }

    // This function allows a doctor to mark a message as read
    function markMessageAsRead(address patientAddress, uint messageIndex) public {
        // Get the messages for the patient
        Message[] memory patientMessages = messages[patientAddress];

        // Get the message at the specified index
        Message memory message = patientMessages[messageIndex];

        // Mark the message as read
        message.isRead = true;

        // Update the message in the array
        patientMessages[messageIndex] = message;

        // Update the messages in the mapping
        messages[patientAddress] = patientMessages;
    }

}