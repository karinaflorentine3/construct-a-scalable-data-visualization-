Solidity

pragma solidity ^0.8.0;

contract ScalableDataVisualizationTracker {
    // Mapping of trackers to their respective data
    mapping (address => DataTracker) public trackers;

    // Struct to represent data tracker
    struct DataTracker {
        string name;
        uint256[] data;
        uint256[] timestamps;
    }

    // Event emitted when new data is added to a tracker
    event NewDataAdded(address trackerAddress, uint256[] data, uint256[] timestamps);

    // Function to create a new data tracker
    function createTracker(string memory _name) public {
        address trackerAddress = address(new DataTrackerContract());
        trackers[trackerAddress] = DataTracker(_name, new uint256[](0), new uint256[](0));
        emit NewTrackerCreated(trackerAddress, _name);
    }

    // Function to add new data to an existing tracker
    function addData(address _trackerAddress, uint256[] memory _data, uint256[] memory _timestamps) public {
        DataTracker storage tracker = trackers[_trackerAddress];
        tracker.data = _data;
        tracker.timestamps = _timestamps;
        emit NewDataAdded(_trackerAddress, _data, _timestamps);
    }

    // Function to get data from a tracker
    function getData(address _trackerAddress) public view returns (uint256[] memory, uint256[] memory) {
        DataTracker storage tracker = trackers[_trackerAddress];
        return (tracker.data, tracker.timestamps);
    }
}

contract DataTrackerContract {
    ScalableDataVisualizationTracker public tracker;

    constructor() {
        tracker = ScalableDataVisualizationTracker(msg.sender);
    }

    // Function to add new data to the tracker (only callable by the tracker contract)
    function addData(uint256[] memory _data, uint256[] memory _timestamps) public {
        tracker.addData(address(this), _data, _timestamps);
    }
}