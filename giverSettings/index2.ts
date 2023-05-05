// import { Address, Contract, Giver, ProviderRpcClient, Transaction } from "locklift";
// import { Ed25519KeyPair } from "everscale-standalone-client";

// export class GiverWallet implements Giver {
//   public giverContract: Contract<typeof giverWallet>;

//   constructor(provider: ProviderRpcClient, readonly keyPair: Ed25519KeyPair, address: string) {
//     const giverAddr = new Address(address);
//     this.giverContract = new provider.Contract(giverWallet, giverAddr);
//   }

//   public async sendTo(sendTo: Address, value: string): Promise<{ transaction: Transaction; output?: {} }> {
//     return await this.giverContract.methods
//       .sendTransaction({
//         dest: sendTo,
//         value: value,
//         bounce: false,
//         flags: 3,
//         payload: "",
//       })
//       .sendExternal({ publicKey: this.keyPair.publicKey });
//   }
// }

// const giverWallet = {
//   "ABI version": 2,
//   version: "2.3",
//   header: ["pubkey", "time", "expire"],
//   functions: [
//     {
//       name: "sendTransaction",
//       inputs: [
//         { name: "dest", type: "address" },
//         { name: "value", type: "uint128" },
//         { name: "bounce", type: "bool" },
//         { name: "flags", type: "uint8" },
//         { name: "payload", type: "cell" },
//       ],
//       outputs: [],
//     },
//   ],
//   events: [],
// } as const;
