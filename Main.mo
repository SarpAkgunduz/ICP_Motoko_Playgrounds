import Icrc1Ledger "Icrc1Ledger";
import Debug "mo:base/Debug";
import Result "mo:base/Result";
import Option "mo:base/Option";

actor {
    stable var state = 0;

    type Account = {
        owner: Principal;
        subaccount: ?[Nat8];
    };

    type TransferArgs = {
        amount: Nat;
        toAccount: Account;
    };

    public shared({ caller }) func transfer(args: TransferArgs) : async Result.Result<Icrc1Ledger.BlockIndex, Text> {
        Debug.print(
            "Transferring "
            # debug_show(args.amount)
            # " tokens to account "
            # debug_show(args.toAccount)
        );

        let transferArgs: Icrc1Ledger.TransferArg = {
            memo = null;
            amount = args.amount;
            from_subaccount = null;
            fee = null;
            to = {
                owner = args.toAccount.owner;
                subaccount = args.toAccount.subaccount; // Use the optional value directly
            };
            created_at_time = null;
        };

        let result = await Icrc1Ledger.transfer(transferArgs);

        switch (result) {
            case (#ok blockIndex) {
                return #ok(blockIndex);
            };
            case (#err err) {
                return #err(err);
            };
        };
    };
};
