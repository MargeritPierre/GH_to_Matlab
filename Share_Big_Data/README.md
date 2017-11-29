# Share Big Data Example

Here, Matlab is used to solve a pseudo mechanical problem : a membrane clamped on two edges, in which is applied a point load.

Because sending LONG messages by UDP is not very safe (some info can be lost), this example uses INPUT and OUTPUT text files to share data betweeen the two softwares. UDP is only used to send triggers (booleans) between the two softwares.
