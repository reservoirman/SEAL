SEAL
====

Simple Embedded Avionics Language

Simple Embedded Avionics Language (SEAL) is a programming language that simplifies the programming tasks most commonly found in embedded systems development, particularly in the avionics industry.  Avionics often perform continuous calculations and logging of various data points relevant to space-craft/aircraft performance, and always send out diagnostic and/or telemetric data to the ground.  To support the implementation of this, tasks such as accessing a variable by its address, swapping the bytes of a variable in order to support both Big as well as Little Endian architectures, and creating deterministic, thread-safe and reentrant code are all made much easier with SEAL.  Not only will the lines of code decrease compared to its C, Ada, and C++ counterparts, the reduced source code will also lead to less headaches, more sleep, and more project throughput.  Various architectures will be supported, but for the purposes of this proposal we shall target the ARMv7-A architecture using the Android NDK compiler. It is common in many embedded systems and will find its way into the avionics industry shortly.

SEAL is strongly and statically typed, case-sensitive, procedural, and can be object oriented.

SEAL also supports various avionics communications protocols, such as the various ARINC protocols.