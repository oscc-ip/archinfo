## Datasheet

### Overview
The archinfo IP is a fully parameterised soft IP recording the SoC architecture and ASIC backend informations. The IP features an APB4 slave interface, fully compliant with the AMBA APB Protocol Specification v2.0.

### Feature
* 32-bit read-only system architecture register
* 64-bit read-only id architecture register
* Static synchronous design
* Full synthesizable

### Interface
| port name | type        | description          |
|:--------- |:------------|:---------------------|
| apb4      | interface   | apb4 slave interface |

### Register

| name | offset  | length | description |
|:----:|:-------:|:-----: | :---------: |
| [SYS](#system-info-register) | 0x0 | 4 | system info register |
| [IDL](#id-low-reigster) | 0x4 | 4 | id low register |
| [IDH](#id-high-reigster) | 0x8 | 4 | id high register |

#### System Info Register
| bit | access  | description |
|:---:|:-------:| :---------: |
| `[31:20]` | none | reserved |
| `[19:8]` | RW | CLOCK |

#### ID Low Reigster
#### ID High Reigster


### Program Guide
### Resoureces
### References
### Revision History