/*
/// Module: chiikawa_coin
// module chiikawa_coin::chiikawa_coin;
*/

// For Move coding conventions, see
// https://docs.iota.org/developer/iota-101/move-overview/conventions

module chiikawa_coin::chiikawa_coin;

use iota::coin::{Self, TreasuryCap, Coin};
use iota::url;
use iota::transfer::{Self, transfer};

public struct CHIIKAWA_COIN has drop {}

fun init(witness: CHIIKAWA_COIN, ctx: &mut TxContext) {
    let (mut treasury_cap, coin_metadata) = coin::create_currency(
        witness,
        9,
        b"chiikawa",
        b"chiikawa",
        b"chiikawa",
        option::some(url::new_unsafe_from_bytes(b"https://static.wikia.nocookie.net/chiikawa/images/2/2c/AdorableCutieChiikawa.png/revision/latest?cb=20240709065538")),
        ctx
    );

    transfer::public_freeze_object(coin_metadata);
    transfer::public_transfer(treasury_cap, ctx.sender());
}

public entry fun mint_coin<T>(
    treasury_cap: &mut TreasuryCap<T>,
    amount: u64,
    ctx: &mut TxContext
) {
    let coins = coin::mint<T>(treasury_cap, amount, ctx);
    transfer::public_transfer(coins, tx_context::sender(ctx));
}