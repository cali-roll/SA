import React from "react";

export function Claim({ ClaimTokens }) {
  return (
    <div>
      <h4>claim donations</h4>
      <form
        onSubmit={(event) => {
          // This function just calls the transferTokens callback with the
          // form's data.
          event.preventDefault();

          const formData = new FormData(event.target);
          const to = formData.get("to");
        //   const amount = formData.get("amount");

          if (to) {
            ClaimTokens(to);
          }
        }}
      >
        {/* <div className="form-group">
          <label>Amount of ethers you donate</label>
          <input
            className="form-control"
            type="string"          
            name="amount"
            placeholder="0.001"
            required
          />
        </div> */}
        <div className="form-group">
          <label>your DNS(ex, ens.domains)</label>
          <input className="form-control" type="text" name="to" required />
        </div>
        <div className="form-group">
          <input className="btn btn-primary" type="submit" value="Claim" />
        </div>
      </form>
    </div>
  );
}
