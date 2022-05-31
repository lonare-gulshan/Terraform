variable "location" {
  #type        = string
 default     = "north europe"
  description = "demo 1"
}

variable "name" {
  #type        = list
  default = "demo5"
  description = "demo 1"
}

variable "vnetname" {
  #type        = list
  default = "tempvnet"
  description = "demo 1"
}

variable "vmname" {
  #type        = list
  default = ["vm1", "vm2"]
  description = "demo 1"
}

variable "osdisk" {
  #type        = list
  default = ["tempdisk1", "tempdisk2","tempdisk3"]
  description = "demo 1"
}

variable "nic" {
  #type        = list
  default = ["nic1", "nic2"]
  description = "demo 1"
}

variable "ipconfiguration" {
  #type        = list
  default = ["ip1", "ip2"]
  description = "demo 1"
}

/*variable "subnet" {
  type        = string
  default = ["subnet1","subnet2"]
  description = "demo 1"
}*/