#[starknet::interface]
pub trait IRewardSystem<TContractState> {
    fn add_points(ref self: TContractState, amount: felt252);
    fn redeem_points(self: @TContractState) -> felt252;
}

#[starknet::contract]
mod RewardSystem {
    use starknet::storage::{
        StoragePointerReadAccess, StoragePointerWriteAccess, StoragePathEntry, Map
    };
    use core::starknet::{ContractAddress, get_caller_address};


    #[storage]
    struct Storage {
        balance: Map<ContractAddress, felt252>, 
    }
    
    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        AddPoints: AddPoints,
        RedeemPoints: RedeemPoints
    }
    #[derive(Drop, starknet::Event)]
    struct AddPoints {
        #[key]
        user: ContractAddress,
        balance: felt252,
    }

    
    #[derive(Drop, starknet::Event)]
    struct RedeemPoints {
        user: ContractAddress,
        redeemed_amount: felt252,
    }

    

    #[abi(embed_v0)]
    impl RewardSystemImpl of super::IRewardSystem<ContractState> {
        fn add_points(ref self: ContractState, amount: felt252) {
            assert(amount != 0, 'Amount cannot be 0');
            let caller = get_caller_address();
            let current = self.balance.entry(caller).read();
            let add_point = current + amount;
            self.balance.entry(caller).write(add_point);
            self.emit(AddPoints { user: caller, balance: add_point });
        }
        
        fn redeem_points(self: @ContractState) -> felt252 {
            let caller = get_caller_address();
            let redeem_points = self.balance.entry(caller).read();
            self.emit(RedeemPoints { user: caller, balance: add_point });
            return redeem_points;
           
        }
    }
}
