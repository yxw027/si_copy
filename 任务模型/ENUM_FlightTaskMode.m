classdef ENUM_FlightTaskMode < Simulink.IntEnumType
    %UNTITLED 此处显示有关此类的摘要
    %   此处显示详细说明
    enumeration
        NoneFlightTaskMode (0),
        GroundStandByMode (1),
        TakeOffMode (2),
        Rotor2Fix_Mode (3),
        HoverAdjustMode (4),
        HoverUpMode (5),
        PathFollowMode (6),
        AirStandByMode (7),
        GoHomeMode (8),
        HoverDownMode (9),
        Fix2Rotor_Mode (10),
        LandMode (11),
        FenceRecoverMode (12),
        SpotCircleMode (13),
        StallRecovery (14),
        
        Test_HeightKeep (101),
        Test_AttitudeKeep (102),
        Test_HeadingKeep (103),
        Test_SpotCircle (104)
    end
end