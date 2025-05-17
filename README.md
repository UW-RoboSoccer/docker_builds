# docker_builds
Docker container builds

``` mermaid

classDiagram
    class perception {
        Camera Interfacing
        Publishes:
        - [PoseStamped] /ball_pose
        %%Subscribes to:
        %%- [Image] /camera/image_raw
    }

    class firmware {
        STM32
        Publishes:
        - [JointState] /joint_state
        - [Float32] /imu/data
        - [Float32] /imu/euler_ori
        - [Float32] /left/force
        - [Float32] /right/force
        Subscribes to:
        - [JointState] /joint_cmd
    }

    class localization {
        Figures out robot's position on the field
        Publishes:
        - [PoseStamped] /robot_pose
        Subscribes to:
        - [PoseStamped] /ball_pose
        - [Float32] /imu/data
    }

    class world_model {
        Maintains a full map of the field, ball, players
        Publishes:
        - [String] /world_state
        Subscribes to:
        - [PoseStamped] /ball_pose
        - [PoseStamped] /robot_pose
    }

    class behaviour {
        Decides what the robot should do next
        Publishes:
        - [String] /behaviour_state
        Subscribes to:
        - [String] /world_state
    }
    
    class motion {
        Plans footsteps and body movement paths
        Publishes:
        - [String] /footsteps
        - [PoseStamped] /target_pose
        Subscribes to:
        - [String] /behaviour_state
        - [JointState] /joint_state
        - [Float32] /imu/data
        - [Float32] /imu/euler_ori
        - [Float32] /left/force
        - [Float32] /right/force
    }

    class control {
        Executes walking, balance, and skills
        Publishes:
        - [JointState] /joint_cmd 
        Subscribes to:
        - [String] /footsteps
        - [PoseStamped] /target_pose
    }

    perception --|> world_model : /ball_pose
    perception --|> localization : /ball_pose
    behaviour --|> motion : /behaviour_state
    motion --|> control : /footsteps
    motion --|> control : /target_pose
    %%firmware --|> perception : /camera/image_raw
    firmware --|> localization : /imu/data
    control --|> firmware : /joint_cmd
    localization --|> world_model : /robot_pose
    world_model --|> behaviour : /world_state
    firmware --|> motion : /joint_state
    firmware --|> motion : /imu/data
    firmware --|> motion : /imu/euler_ori
    firmware --|> motion : /left/force
    firmware --|> motion : /right/force
```

# Dev container helper scripts

## Image Scripts
These scripts help build and remove container images for when the container environment changes or when a robot is first set up.
- `build_dev_images.sh`: Builds all defined dev containers using Dockerfiles in `/dev_containers`
- `remove_dev_images.sh`: Removes all defined dev containers
## Container Scripts
- `clone_repos.sh`: Clones all required repos
- `stop_containers.sh`: Gently stops running containers
- `kill_containers.sh`: Quickly kills running containers
- `clear_dev_containers.sh`: Clears stopped or killed containers


The startup and clone scripts read from the `git_repos` file to map mounted directories to github clone links.
The startup script also reads from the `docker-compose.yml` file to know which containers to start and their target mount directories.
