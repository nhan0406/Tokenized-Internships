module tokenised-internship-project-file::TokenizedInternship {

    use aptos_framework::signer;
    use aptos_framework::coin;
    use aptos_framework::aptos_coin::AptosCoin;
    use std::vector;

    /// Struct representing an internship
    struct Internship has store, key {
        employer: address,
        intern: address,
        task_count: u64,
        completed_tasks: u64,
        reward_per_task: u64,
    }

    /// Map employer address to a vector of internships
    struct InternshipRegistry has store, key {
        internships: vector<Internship>,
    }

    /// Error codes
    const INVALID_TASK: u64 = 100;
    const NO_TASKS_LEFT: u64 = 101;

    /// Initialize the internship registry for the employer
    public fun init_registry(employer: &signer) {
        let employer_addr = signer::address_of(employer);
        let registry = InternshipRegistry {
            internships: vector::empty<Internship>(),
        };
        move_to(employer, registry);
    }

    /// Function to create a new internship with a specified number of tasks and rewards per task.
    public fun create_internship(
        employer: &signer, 
        intern: address, 
        task_count: u64, 
        reward_per_task: u64
    ) acquires InternshipRegistry {
        let employer_addr = signer::address_of(employer);

        // Create a new internship
        let new_internship = Internship {
            employer: employer_addr,
            intern,
            task_count,
            completed_tasks: 0,
            reward_per_task,
        };

        // Add the internship to the employer's registry
        let registry = borrow_global_mut<InternshipRegistry>(employer_addr);
        vector::push_back(&mut registry.internships, new_internship);
    }

    /// Function to complete a task and reward the intern.
    public fun complete_task(
        intern_signer: &sign)
        